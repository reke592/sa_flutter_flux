import 'package:sa_flutter_flux/sa_flutter_flux.dart';

class Todo implements Serializable {
  int? id;
  String task;

  Todo({
    this.id,
    required this.task,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      task: json['task'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
    };
  }
}
