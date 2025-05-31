import 'package:vox_app/feature/domain/entities/todo.dart';

class TodoModel extends TodoEntity {
  TodoModel({
    super.id,
    required super.title,
    required super.description,
    required super.categoryId,
    super.completed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'completed': completed,
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? 1,
      completed: json['completed'] ?? false,
    );
  }
}
