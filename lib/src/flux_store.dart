import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sa_flutter_flux/src/store_action.dart';

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

  /// run [Action] and apply commits to this store.
  ///
  /// use [onError] to run [BuildContext] related process.
  Future<void> dispatch<T extends FluxStore>(
    StoreAction action, {
    void Function(dynamic error, StackTrace stackTrace)? onError,
  }) {
    return action
        .effect(this)
        .then((result) => action.apply(this, result))
        .onError((error, stackTrace) {
      onError?.call(error, stackTrace);
      return action.rollback(this, error, stackTrace);
    });
  }
}
