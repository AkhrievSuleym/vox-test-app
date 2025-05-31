import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vox_app/core/utils/loading_widget.dart';
import 'package:vox_app/feature/domain/entities/todo_entity.dart';
import 'package:vox_app/feature/presentation/providers/category_provider.dart';
import 'package:vox_app/feature/presentation/providers/todo_providers.dart';

class TodoCreateScreen extends ConsumerStatefulWidget {
  const TodoCreateScreen({super.key});

  @override
  _TodoCreateScreenState createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends ConsumerState<TodoCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  int? _categoryId;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(getCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create ToDo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              categories.when(
                data: (cats) => DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: _categoryId,
                  items: cats
                      .map((cat) => DropdownMenuItem<int>(
                            value: cat.id,
                            child: Text(cat.name),
                          ))
                      .toList(),
                  onChanged: (value) => _categoryId = value,
                  validator: (value) =>
                      value == null ? 'Category is required' : null,
                ),
                loading: () => const LoadingIcon(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final todo = TodoEntity(
                      title: _title,
                      description: _description,
                      categoryId: _categoryId!,
                    );
                    await ref.read(createTodoProvider(todo).future);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
