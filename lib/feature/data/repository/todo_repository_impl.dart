import 'package:dartz/dartz.dart';
import 'package:vox_app/core/error/failures.dart';
import 'package:vox_app/core/network/connection.dart';
import 'package:vox_app/feature/data/datasources/remote_data_source.dart';
import 'package:vox_app/feature/data/models/category_model.dart';
import 'package:vox_app/feature/data/models/todo_model.dart';
import 'package:vox_app/feature/domain/entities/todo_entity.dart';
import 'package:vox_app/feature/domain/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final RemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  TodoRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, List<TodoModel>>> getTodos() async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      final todoModels = await remoteDataSource.getTodos();
      return right(todoModels);
    } catch (e) {
      return left(Failure('Failed to load todos: $e'));
    }
  }

  @override
  Future<Either<Failure, TodoModel>> createTodo(TodoEntity todo) async {
    if (!await connectionChecker.isConnected) {
      return left(Failure('No internet connection'));
    }
    try {
      final todoModel = TodoModel(
        title: todo.title,
        description: todo.description,
        categoryId: todo.categoryId,
        completed: todo.completed,
      );
      final result = await remoteDataSource.createTodo(todoModel);
      return right(result);
    } catch (e) {
      return left(Failure('Failed to create todo: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final categoryModels = await remoteDataSource.getCategories();
      return right(categoryModels);
    } catch (e) {
      return left(Failure('Failed to fetch categories: $e'));
    }
  }
}
