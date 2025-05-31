import 'package:dartz/dartz.dart';
import 'package:vox_app/core/error/failures.dart';
import 'package:vox_app/core/usecase/usecase.dart';
import 'package:vox_app/feature/domain/entities/todo_entity.dart';
import 'package:vox_app/feature/domain/repository/todo_repository.dart';

class GetTodos implements UseCase<List<TodoEntity>, EmptyParams> {
  final TodoRepository repository;

  GetTodos(this.repository);

  @override
  Future<Either<Failure, List<TodoEntity>>> call(EmptyParams params) async {
    return await repository.getTodos();
  }
}
