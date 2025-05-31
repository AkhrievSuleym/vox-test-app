import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vox_app/feature/presentation/pages/todo_create_page.dart';
import 'package:vox_app/feature/presentation/providers/category_provider.dart';
import 'package:vox_app/feature/presentation/providers/todo_providers.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider(null));
    final categories = ref.watch(getCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('To-do list')),
      body: Column(
        children: [
          categories.when(
            data: (cats) => DropdownButton<int?>(
              value: null,
              hint: const Text('All Categories'),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('All')),
                ...cats.map((cat) => DropdownMenuItem<int?>(
                      value: cat.id,
                      child: Text(cat.name),
                    )),
              ],
              onChanged: (value) {
                ref.read(filteredTodosProvider(value).notifier).state = value !=
                        null
                    ? todos.where((todo) => todo.categoryId == value).toList()
                    : todos;
              },
            ),
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
          Expanded(
            child: ref.watch(getTodosProvider).when(
                  data: (todoList) => ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      final todo = todoList[index];
                      return ListTile(
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        trailing: Text('Cat: ${todo.categoryId}'),
                      );
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TodoCreateScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
