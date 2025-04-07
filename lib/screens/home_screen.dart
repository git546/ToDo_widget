import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final todos = todoProvider.todos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("할 일 목록"),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return Dismissible(
            key: Key(todo.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              context.read<TodoProvider>().deleteTodo(todo.id!);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('할 일이 삭제되었습니다')),
              );
            },
            child: ListTile(
              title: Text(todo.title),
              trailing: Checkbox(
                value: todo.isDone,
                onChanged: (value) {
                  context.read<TodoProvider>().updateTodo(
                    Todo(
                      id: todo.id,
                      title: todo.title,
                      isDone: value ?? false,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("할 일 추가"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "할 일을 입력하세요"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                context.read<TodoProvider>().addTodo(
                  Todo(title: text),
                );
              }
              Navigator.pop(context);
            },
            child: const Text("추가"),
          ),
        ],
      ),
    );
  }
}
