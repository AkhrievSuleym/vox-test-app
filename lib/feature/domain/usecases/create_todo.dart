import 'package:dartz/dartz.dart';
import 'package:vox_app/core/error/failures.dart';
import 'package:vox_app/core/usecase/usecase.dart';
import 'package:vox_app/feature/domain/entities/todo.dart';
import 'package:vox_app/feature/domain/repository/todo_repository.dart';

class CreateTodo implements UseCase<TodoEntity, TodoParams> {
  final TodoRepository repository;

  CreateTodo(this.repository);

  @override
  Future<Either<Failure, TodoEntity>> call(TodoParams params) async {
    return await repository.createTodo(params.todo);
  }
}

class TodoParams {
  final TodoEntity todo;

  TodoParams({required this.todo});
}
