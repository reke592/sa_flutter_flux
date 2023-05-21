import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sa_flutter_flux/sa_flutter_flux.dart';

typedef StoreMutations = Map<String, FutureOr<void> Function(dynamic payload)>;

abstract class FluxStore extends ChangeNotifier {
  FluxStore() {
    _mutations = createMutations();
  }

  late final StoreMutations _mutations;

  /// event handlers on [commit].
  @protected
  StoreMutations createMutations();

  /// triggers event mutation handler and call [notifyListeners].
  Future<void> commit(String event, dynamic result) async {
    if (_mutations.containsKey(event)) {
      await _mutations[event]!(result);
      notifyListeners();
    } else {
      debugPrint('missing store event handler for $event');
    }
  }

  /// run [StoreAction] and apply commits to this store.
  ///
  /// use [onError] callback to run [BuildContext] related process.
  Future<void> dispatch<T extends FluxStore>(
    StoreAction action, {
    void Function(dynamic error, StackTrace stackTrace)? onError,
    bool ignoreCache = false,
  }) async {
    if (!ignoreCache) {
      if (await _satisfyWithCache(action)) return;
    }
    return action.effect(this).then((result) async {
      // apply store mutations
      await action.apply(this, result);
      // update cache
      if (action is CacheResult) {
        return action.saveCache(result);
      }
      return result;
    }).onError((error, stackTrace) {
      onError?.call(error, stackTrace);
      return action.rollback(this, error, stackTrace);
    });
  }

  /// load [CacheData] and call [StoreAction.apply].
  ///
  /// return [CacheResult.satisfyWithCache] to skip [StoreAction.effect].
  Future<bool> _satisfyWithCache(StoreAction action) async {
    if (action is CacheResult) {
      var cache = await action.getCache();
      if (cache == null) return false;
      await action.apply(this, action.fromCache(cache));
      return action.satisfyWithCache;
    }
    return false;
  }
}
