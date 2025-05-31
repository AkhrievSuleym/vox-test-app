import 'package:dartz/dartz.dart';
import 'package:vox_app/core/error/failures.dart';
import 'package:vox_app/feature/domain/entities/category_entity.dart';

import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoEntity>>> getTodos();
  Future<Either<Failure, TodoEntity>> createTodo(TodoEntity toDo);
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
