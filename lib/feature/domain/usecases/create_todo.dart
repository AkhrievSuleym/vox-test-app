import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:vox_app/core/error/failures.dart';
import 'package:vox_app/core/usecase/usecase.dart';
import 'package:vox_app/feature/domain/entities/todo_entity.dart';
import 'package:vox_app/feature/domain/repository/todo_repository.dart';

class CreateTodo implements UseCase<TodoEntity, TodoParams> {
  final TodoRepository repository;

  CreateTodo(this.repository);

  @override
  Future<Either<Failure, TodoEntity>> call(TodoParams params) async {
    return await repository.createTodo(params.todo);
  }
}

class TodoParams extends Equatable {
  final TodoEntity todo;

  const TodoParams({required this.todo});

  @override
  List<Object?> get props => [todo];
}
