import 'package:example/todos/data/models/todo.dart';
import 'package:example/todos/data/todo_events.dart';
import 'package:sa_flutter_flux/sa_flutter_flux.dart';

class TodoStore extends FluxStore {
  final List<Todo> _todos = [];

  List<Todo> get todos => List.of(_todos);

  @override
  StoreMutations createMutations() {
    return {
      TodoEvents.load: (payload) {
        _todos.clear();
        _todos.addAll(payload as List<Todo>);
      },
    };
  }
}
