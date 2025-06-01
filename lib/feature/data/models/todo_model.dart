import 'package:vox_app/feature/domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  TodoModel({
    super.id,
    required super.title,
    required super.description,
    required super.categoryId,
    bool completed = false,
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
      id: json['id'] is String
          ? int.tryParse(json['id'].toString())
          : json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      categoryId: json['categoryId'] is String
          ? int.parse(json['categoryId'].toString())
          : (json['categoryId'] as int? ?? 1),
      completed: json['completed'] ?? false,
    );
  }
}
