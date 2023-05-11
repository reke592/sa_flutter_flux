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

Sample Flux store implementation in flutter.

## Features

abstract class and sample to implement flux store.

## Getting started

add the package in `pubspec.yaml`

## Usage

define store events
```dart
abstract class TodoTypeEvents {
  TodoTypeEvents._();
  static const _event = 'todo';
  static const loading = '$_event/loading';
  static const loaded = '$_event/loaded';
  static const created = '$_event/created';
  static const started = '$_event/started';
  static const completed = '$_event/completed';
}
```

define store action and parameters
```dart
class LoadTodoParams {
  int sprintId;
  LoadTodoParams({required this.sprintId});
}

class LoadTodo extends StoreAction<TodoStore, LoadTodoParams, List<Todo>> {
  LoadTodo(super.payload);

  @override
  Future<void> apply(store, result) {
    return store.commit(TodoTypeEvents.loaded, result);
  }

  @override
  Future<List<Todo>> effect(store) async {
    try {
      store.commit(TodoTypeEvents.loading, true);
      // make api call to fetch all todos using payload.sprintId
      // dummy process
      await Future.delayed(const Duration(seconds: 1));
      return List.generate(
        10,
        (index) => Todo(
          id: index + 1,
          sprintId: payload.sprintId,
          task: 'generated sample $index',
          dateCreated: DateTime.now(),
        ),
      );
    } catch (e) {
      rethrow;
    } finally {
      store.commit(TodoTypeEvents.loading, false);
    }
  }
}
```

define store and mutations
```dart

class TodoStore extends FluxStore {
  // state
  bool _isLoading = false;
  final List<Todo> _todos = [];
  final List<Todo> _ongoing = [];
  final List<Todo> _completed = [];

  // computed
  bool get isLoading => _isLoading;
  List<Todo> get todos => List.of(_todos);
  List<Todo> get ongoing => List.of(_ongoing);
  List<Todo> get completed => List.of(_completed);
  String get total =>
      'Total: ${_todos.length + _ongoing.length + _completed.length}';

  // mutations
  @override
  StoreMutations createMutations() {
    return {
      TodoTypeEvents.loading: (payload) {
        _isLoading = payload == true;
      },
      TodoTypeEvents.loaded: (payload) {
        final data = payload as List<Todo>;
        for (var todo in data) {
          if (todo.dateCompleted != null) {
            completed.add(todo);
          }
        }
      }
    };
  }
}
```

## Additional information

FluxStore extends to ChangeNotifier class so we can use Provider to inject the instance in widget tree. We can also use GetIt to make the store accessible without build context.