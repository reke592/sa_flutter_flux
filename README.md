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

Sample Flux store implementation in Flutter.  
**Disclaimer:**
Please note that this package is not intended for production use and should be used at your own risk. It was created as an experimental attempt to implement flux state mutations. Keep in mind that extensive use of List.of in computed getters may have potential implications, and careful consideration should be given to memory usage and performance.

## Features

abstract class to implement unidirectional flow. see [sample](https://github.com/reke592/sa_flutter_flux_sample).  

## Getting started

add the package in `pubspec.yaml`

## Usage

Define store events
```dart
abstract class TodoTypeEvents {
  TodoTypeEvents._();
  static const _event = 'todo';
  static const loading = '$_event/loading';
  static const loaded = '$_event/loaded';
  static const created = '$_event/created';
  static const updated = '$_event/updated';
  static const started = '$_event/started';
  static const completed = '$_event/completed';
}

abstract class StageTypeEvents {
  StageTypeEvents._();
  static const _event = 'stage';
  static const loading = '$_event/loading';
  static const loaded = '$_event/loaded';
  static const created = '$_event/created';
  static const deleted = '$_event/deleted';
}

abstract class TagEvents {
  TagEvents._();
  static const _event = 'tag';
  static const loading = '$_event/loading';
  static const loaded = '$_event/loaded';
  static const created = '$_event/created';
  static const deleted = '$_event/deleted';
}

abstract class ProjectEvents {
  ProjectEvents._();
  static const _event = 'project';
  static const loaded = '$_event/loaded';
}

abstract class ManpowerEvents {
  ManpowerEvents._();
  static const _event = 'manpower';
  static const loading = '$_event/loading';
  static const loaded = '$_event/loaded';
  static const added = '$_event/added';
  static const removed = '$_event/removed';
}
```

Define action and parameters
```dart
class AddTodoParams {
  Project project;
  Employee? assignedEmployee;
  Stage? stage;
  String task;

  AddTodoParams({
    required this.project,
    required this.task,
    this.assignedEmployee,
    this.stage,
  });
}

class AddTodo extends StoreAction<TodoStore, AddTodoParams, Todo> {
  AddTodo(super.payload);

  @override
  Future<void> apply(TodoStore store, Todo result) {
    return store.commit(TodoTypeEvents.created, result);
  }

  @override
  Future<Todo> effect(TodoStore store) async {
    if (payload.task.trim().isEmpty) {
      throw 'Task description is required';
    }
    return Todo(
      id: store.nextTodoId,
      project: payload.project,
      task: payload.task,
      assignedEmployee: payload.assignedEmployee,
      stage: payload.stage ??
          store.stages.firstWhere((element) => element.isInitial),
    );
  }
}
```

Define states and mutations
```dart

class TodoStore extends FluxStore {
  // states
  Project _project = Project.empty();
  bool _isLoadingTodos = false;
  bool _isLoadingStages = false;
  bool _isLoadingTags = false;
  bool _isLoadingManpower = false;
  final List<Stage> _stages = [];
  final List<Tag> _tags = [];
  final List<Todo> _todos = [];
  final List<Employee> _manpower = [];

  // computed
  Project get project => _project;
  int get nextTodoId => _todos.length + 1;
  bool get isLoadingTodos => _isLoadingTodos;
  List<Todo> get todos => List.of(_todos);
  bool get isLoadingManpower => _isLoadingManpower;
  List<Employee> get manpower => List.of(_manpower);
  int get nextStageId => _stages.length + 1;
  bool get isLoadingStages => _isLoadingStages;
  List<Stage> get stages => List.of(_stages);
  int get nextTaskPriorityId => _tags.length + 1;
  bool get isLoadingTags => _isLoadingTags;
  List<Tag> get tags => List.of(_tags);
  List<Todo> todosPerStage(Stage stage) =>
      List.of(_todos.where((element) => element.stage.id == stage.id)).toList();

  @override
  Future<void> commit(String event, dynamic result) {
    debugPrint(event);
    return super.commit(event, result);
  }

  // mutations
  @override
  StoreMutations createMutations() {
    return {
      // sprint
      ProjectEvents.loaded: (payload) {
        var data = payload as Project;
        _project = _project.copyWith(
          id: data.id,
          project: data.project,
          dateKickOff: data.dateKickOff,
          dateLive: data.dateLive,
        );
      },
      // todos
      TodoTypeEvents.loading: (payload) {
        _isLoadingTodos = payload == true;
      },
      TodoTypeEvents.loaded: (payload) {
        _todos.clear();
        _todos.addAll(payload as List<Todo>);
      },
      TodoTypeEvents.created: (payload) {
        var data = payload as Todo;
        _todos.add(data);
      },
      TodoTypeEvents.updated: (payload) {
        var updated = payload as Todo;
        var current = _todos.indexWhere((element) => element.id == updated.id);
        _todos[current] = _todos[current].copyWith(
          id: updated.id,
          task: updated.task,
          assignedEmployee: updated.assignedEmployee,
          dateCompleted: updated.dateCompleted,
          dateCreated: updated.dateCreated,
          dateStarted: updated.dateStarted,
          remarks: updated.remarks,
          project: updated.project,
          stage: updated.stage,
        );
      },
      // stages
      StageTypeEvents.loading: (payload) {
        _isLoadingStages = payload == true;
      },
      StageTypeEvents.loaded: (payload) {
        _stages.clear();
        _stages.addAll(payload as List<Stage>);
      },
      // tags
      TagEvents.loading: (payload) {
        _isLoadingTags = payload == true;
      },
      TagEvents.loaded: (payload) {
        _tags.clear();
        _tags.addAll(payload as List<Tag>);
      },
      // manpower
      ManpowerEvents.loading: (payload) {
        _isLoadingManpower = payload == true;
      },
      ManpowerEvents.loaded: (payload) {
        _manpower.clear();
        _manpower.addAll(payload as List<Employee>);
      },
      ManpowerEvents.added: (payload) {
        var data = payload as Employee;
        _manpower.add(data);
      },
      ManpowerEvents.removed: (payload) {
        var data = payload as Employee;
        _manpower.remove(data);
      }
    };
  }
```

## Additional information

FluxStore extends to ChangeNotifier class so we can use Provider to inject the instance in widget tree. We can also use GetIt to make the store accessible without build context.
