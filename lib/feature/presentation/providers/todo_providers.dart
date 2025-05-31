import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:vox_app/core/network/connection.dart';
import 'package:vox_app/core/usecase/usecase.dart';
import 'package:vox_app/feature/data/datasources/remote_data_source.dart';
import 'package:vox_app/feature/data/repository/todo_repository_impl.dart';
import 'package:vox_app/feature/domain/entities/todo_entity.dart';
import 'package:vox_app/feature/domain/usecases/create_todo.dart';
import 'package:vox_app/feature/domain/usecases/get_todos.dart';

final remoteDataSourceProvider = Provider<RemoteDataSource>(
  (ref) => RemoteDataSourceImpl(http.Client()),
);

final internetConnectionProvider = Provider<InternetConnection>(
  (ref) => InternetConnection(),
);

final connectionCheckerProvider = Provider<ConnectionChecker>(
  (ref) => ConnectionCheckerImpl(ref.read(internetConnectionProvider)),
);

final todoRepositoryProvider = Provider(
  (ref) => TodoRepositoryImpl(
      ref.read(remoteDataSourceProvider), ref.read(connectionCheckerProvider)),
);

final getTodosProvider = FutureProvider<List<TodoEntity>>((ref) async {
  final usecase = GetTodos(ref.read(todoRepositoryProvider));
  final result = await usecase(EmptyParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (todos) => todos,
  );
});

final createTodoProvider =
    FutureProvider.family<void, TodoEntity>((ref, todo) async {
  final usecase = CreateTodo(ref.read(todoRepositoryProvider));
  final result = await usecase(TodoParams(todo: todo));
  result.fold(
    (failure) => throw Exception(failure.message),
    (success) => ref.invalidate(getTodosProvider),
  );
});

final filteredTodosProvider = StateProvider.family<List<TodoEntity>, int?>(
  (ref, categoryId) {
    final todos = ref.watch(getTodosProvider).value ?? [];
    if (categoryId == null) return todos;
    return todos.where((todo) => todo.categoryId == categoryId).toList();
  },
);
