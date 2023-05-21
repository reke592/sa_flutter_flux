import 'dart:convert';

import 'package:example/todos/data/models/todo.dart';
import 'package:example/todos/data/todo_events.dart';
import 'package:example/todos/data/todo_store.dart';
import 'package:sa_flutter_flux/sa_flutter_flux.dart';

class LoadTodoList extends StoreAction<TodoStore, List<Todo>> with CacheResult {
  @override
  Future<void> apply(TodoStore store, List<Todo> result) {
    return store.commit(TodoEvents.load, result);
  }

  @override
  Future<List<Todo>> effect(TodoStore store) async {
    return List.generate(
      3,
      (index) => Todo(id: index + 1, task: 'task $index'),
    );
  }

  @override
  Duration get cacheExpire => const Duration(days: 3);

  @override
  List<Todo> fromCache(CacheData cache) {
    return List<Map<String, dynamic>>.from(jsonDecode(cache.jsonString))
        .map(Todo.fromJson)
        .toList();
  }

  @override
  bool get satisfyWithCache => false;
}
