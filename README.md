<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Sample Flux implementation in Flutter.  
**Disclaimer:**
Please note that this package is not intended for production use and should be used at your own risk. It was created as an experimental attempt to implement flux state mutations. Keep in mind that extensive use of List.of in computed getters may have potential implications, and careful consideration should be given to memory usage and performance.

## Features

Abstract class **FluxStore** and **StoreAction<TStore, TResult>** to implement unidirectional data flow.  
FluxStore is a ChangeNotifier, use the [Provider](https://pub.dev/packages/provider) package to control the store value subscriptions.

### StoreAction<TStore, TResult> methods
```dart
// for validations and async API request
Future<TResult> effect(TStore store)

// on successful effect, use store.commit(String event, dynamic payload) to trigger store mutations.
Future<void> apply(TStore store, TResult result)`

// action handler on error, default: rethrow
Future<void> rollback(TStore store, dynamic error, StackTrace stackTrace)
```

### FluxStore methods
```dart
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
```

## Getting started

add the package in `pubspec.yaml`

## Usage

Define store events
```dart
abstract class CounterEvents {
  CounterEvents._();
  static const _event = 'counter';
  static const updated = '$_event/updated';
  static const reset = '$_event/reset';
}
```

Define action and parameters
```dart
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
```

Define states and mutations
```dart
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
```

Subscribe the using the [Provider](https://pub.dev/packages/provider) Selector
```dart
Selector<CounterStore, int>(
  selector: (_, pvd) => pvd.value,
  builder: (context, value, child) {
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
)
```

Call store dispatch method
```dart
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
```