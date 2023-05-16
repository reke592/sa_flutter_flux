import 'package:example/counter/data/actions/reset_couter.dart';
import 'package:example/counter/data/actions/update_counter.dart';
import 'package:example/counter/data/counter_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterScreen extends StatelessWidget {
  static const routeName = '/counter';
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('-- $runtimeType.build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Demo'),
      ),
      body: Center(
        child: Selector<CounterStore, int>(
          selector: (_, pvd) => pvd.value,
          builder: (context, value, child) {
            debugPrint('-- $runtimeType.Selector.builder');
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child!,
                  Text(
                    '$value',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            );
          },
          child: const Text('You have pushed the button this many times:'),
        ),
      ),
      floatingActionButton: Wrap(
        spacing: 8,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              context
                  .read<CounterStore>()
                  .dispatch(UpdateCounterAction(step: 1));
            },
          ),
          FloatingActionButton(
            child: const Icon(Icons.restart_alt),
            onPressed: () {
              context.read<CounterStore>().dispatch(ResetCounterAction());
            },
          ),
        ],
      ),
    );
  }
}
