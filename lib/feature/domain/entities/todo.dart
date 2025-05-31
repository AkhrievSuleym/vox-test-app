class TodoEntity {
  final int? id;
  final String title;
  final String description;
  final int categoryId;
  final bool completed;

  TodoEntity({
    this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    this.completed = false,
  });
}
