import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vox_app/core/usecase/usecase.dart';
import 'package:vox_app/feature/domain/entities/category_entity.dart';
import 'package:vox_app/feature/domain/usecases/get_categories.dart';
import 'package:vox_app/feature/presentation/providers/todo_providers.dart';

final getCategoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final usecase = GetCategories(ref.read(todoRepositoryProvider));
  final result = await usecase(EmptyParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (categories) => categories,
  );
});
