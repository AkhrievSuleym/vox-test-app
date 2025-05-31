class Todo {
  final int? id;
  final String title;
  final String descrition;
  final int categoryId;
  final bool completed;

  Todo({
    this.id,
    required this.title,
    required this.descrition,
    required this.categoryId,
    this.completed = false,
  });
}
