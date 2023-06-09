import 'package:sa_flutter_flux/src/flux_store.dart';

abstract class StoreAction<TStore extends FluxStore, TResult> {
  /// the process to run.
  ///
  /// > eg. api request
  ///
  /// this may include validations for immediate throws.
  Future<TResult> effect(TStore store);

  /// called after success [effect].
  ///
  /// use [FluxStore.commit] to update state.
  Future<void> apply(TStore store, TResult result);

  /// called after failed [effect].
  ///
  /// error will be propagated to [FluxStore.dispatch] `onError` handler for [BuildContext] related process.
  ///
  /// can optionally use [FluxStore.commit] to update state.
  Future<void> rollback(TStore store, dynamic error, StackTrace stackTrace) {
    throw error;
  }
}
