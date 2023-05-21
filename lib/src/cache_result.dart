import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sa_flutter_flux/sa_flutter_flux.dart';

/// StoreAction mixin to support offline cache
mixin CacheResult<TStore extends FluxStore, TResult>
    on StoreAction<TStore, TResult> {
  @protected
  Duration get cacheExpire;

  /// cache key
  @protected
  String get cacheName => '$runtimeType';

  /// setting this value to `true` will skip [StoreAction.effect] when cache is valid
  ///
  /// this can be overridden in [FluxStore.dispatch] method flag ignoreCache
  bool get satisfyWithCache;

  /// json to object mapper
  TResult fromCache(CacheData cache);

  /// save cache to offline database
  Future<void> saveCache(TResult result) async {
    /// TODO: offline database and unit test
  }

  /// clear existing result cache
  Future<void> clearCache() async {
    /// TODO: offline database and unit test
  }

  /// recently cached result
  Future<CacheData?> getCache() async {
    /// TODO: offline database and unit test
    return null;
  }
}
