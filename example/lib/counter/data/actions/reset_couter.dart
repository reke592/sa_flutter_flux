import 'package:example/counter/data/counter_events.dart';
import 'package:example/counter/data/counter_store.dart';
import 'package:sa_flutter_flux/sa_flutter_flux.dart';

class ResetCounterAction extends StoreAction<CounterStore, int> {
  final int initialValue;

  ResetCounterAction({
    this.initialValue = 0,
  });

  @override
  Future<void> apply(CounterStore store, int result) {
    return store.commit(CounterEvents.reset, result);
  }

  @override
  Future<int> effect(CounterStore store) async {
    // validations | api request
    return initialValue; // as result
  }
}
