import 'package:example/counter/data/counter_events.dart';
import 'package:sa_flutter_flux/sa_flutter_flux.dart';

class CounterStore extends FluxStore {
  // state
  int _value = 0;

  // computed
  int get value => _value;

  // mutations
  @override
  StoreMutations createMutations() {
    return {
      CounterEvents.updated: (payload) {
        _value += (payload as int);
      },
      CounterEvents.reset: (payload) {
        _value = payload as int;
      },
    };
  }
}
