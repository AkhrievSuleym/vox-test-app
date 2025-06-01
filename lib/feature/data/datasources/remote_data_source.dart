import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vox_app/core/error/exceptions.dart';
import 'package:vox_app/feature/data/models/category_model.dart';
import 'package:vox_app/feature/data/models/todo_model.dart';

abstract interface class RemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> createTodo(TodoModel todo);
  Future<List<CategoryModel>> getCategories();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://683b949828a0b0f2fdc4fa6d.mockapi.io/todos';

  RemoteDataSourceImpl(this.client);

  @override
  Future<List<TodoModel>> getTodos() async {
    final response = await client.get(Uri.parse('$baseUrl/todos'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((todo) => TodoModel.fromJson({
                ...todo,
                'description': todo['description'] ?? 'There is no description',
                'categoryId': todo['categoryId'],
              }))
          .toList();
    } else {
      throw ServerException('Failed to load!');
    }
  }

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    final response = await client.post(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(todo.toJson()),
    );
    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['id'] is String) {
        jsonResponse['id'] = int.tryParse(jsonResponse['id']);
      }
      return TodoModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to create todo');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    return [
      CategoryModel(id: 1, name: 'Work'),
      CategoryModel(id: 2, name: 'Personal'),
      CategoryModel(id: 3, name: 'Others'),
    ];
  }
}
