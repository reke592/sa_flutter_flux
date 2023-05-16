import 'package:example/counter/data/counter_events.dart';
import 'package:example/counter/data/counter_store.dart';
import 'package:sa_flutter_flux/sa_flutter_flux.dart';

class UpdateCounterAction extends StoreAction<CounterStore, int> {
  final int step;

  UpdateCounterAction({
    required this.step,
  });

  @override
  Future<void> apply(CounterStore store, int result) {
    return store.commit(CounterEvents.updated, result);
  }

  @override
  Future<int> effect(CounterStore store) async {
    // validations | api request
    return step; // as result
  }
}
