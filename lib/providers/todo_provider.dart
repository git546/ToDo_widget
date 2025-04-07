import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../db/todo_database.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  // DB에서 초기 데이터 불러오기
  Future loadTodos() async {
    _todos = await TodoDatabase.instance.readAllTodos();
    notifyListeners(); // UI 갱신
  }

  // 할 일 추가
  Future addTodo(Todo todo) async {
    final newTodo = await TodoDatabase.instance.create(todo);
    _todos.add(newTodo);
    notifyListeners();
  }

  // 할 일 수정
  Future updateTodo(Todo todo) async {
    await TodoDatabase.instance.update(todo);
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      notifyListeners();
    }
  }

  // 할 일 삭제
  Future deleteTodo(int id) async {
    await TodoDatabase.instance.delete(id);
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
