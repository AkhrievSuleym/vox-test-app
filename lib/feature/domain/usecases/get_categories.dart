import 'package:dartz/dartz.dart';
import 'package:vox_app/core/error/failures.dart';
import 'package:vox_app/core/usecase/usecase.dart';
import 'package:vox_app/feature/domain/entities/category.dart';
import 'package:vox_app/feature/domain/repository/todo_repository.dart';

class GetCategories implements UseCase<List<CategoryEntity>, EmptyParams> {
  final TodoRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(EmptyParams params) async {
    return await repository.getCategories();
  }
}
