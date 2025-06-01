import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vox_app/core/utils/loading_widget.dart';
import 'package:vox_app/feature/presentation/pages/todo_create_page.dart';
import 'package:vox_app/feature/presentation/providers/category_provider.dart';
import 'package:vox_app/feature/presentation/providers/todo_providers.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final todos = ref.watch(filteredTodosProvider(selectedCategory));
    final categories = ref.watch(getCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ToDo List')),
      body: Column(
        children: [
          categories.when(
            data: (cats) => DropdownButton<int?>(
              value: selectedCategory,
              hint: const Text('All Categories'),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('All')),
                ...cats.map((cat) => DropdownMenuItem<int?>(
                      value: cat.id,
                      child: Text(cat.name),
                    )),
              ],
              onChanged: (value) {
                ref.read(selectedCategoryProvider.notifier).state = value;
              },
            ),
            loading: () => const LoadingIcon(),
            error: (e, _) => Text('Error: $e'),
          ),
          Expanded(
            child: todos.isEmpty
                ? const Center(child: Text('No tasks available'))
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        trailing: Text('Cat: ${todo.categoryId}'),
                      );
                    },
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
