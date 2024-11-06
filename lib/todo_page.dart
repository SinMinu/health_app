import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _todoController = TextEditingController();
  List<Map<String, dynamic>> _todoList = [];

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  // 저장된 할 일 목록 불러오기
  Future<void> _loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todoListString = prefs.getString('todoList');
    if (todoListString != null) {
      setState(() {
        _todoList = List<Map<String, dynamic>>.from(json.decode(todoListString));
      });
    }
  }

  // 할 일 목록 저장하기
  Future<void> _saveTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String todoListString = json.encode(_todoList);
    await prefs.setString('todoList', todoListString);
  }

  // 할 일 추가하기
  void _addTodo() {
    setState(() {
      if (_todoController.text.isNotEmpty) {
        _todoList.add({'task': _todoController.text, 'completed': false});
        _todoController.clear();
        _saveTodoList(); // 새 할 일을 추가할 때마다 저장
      }
    });
  }

  // 할 일 삭제하기
  void _deleteTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
      _saveTodoList(); // 할 일을 삭제할 때마다 저장
    });
  }

  // 할 일 완료 상태 변경하기
  void _toggleTodoCompletion(int index) {
    setState(() {
      _todoList[index]['completed'] = !_todoList[index]['completed'];
      _saveTodoList(); // 완료 상태를 변경할 때마다 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    // ThemeProvider를 사용하여 전역 테마 색상 가져오기
    final themeColor = Provider.of<ThemeProvider>(context).themeColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        labelText: 'Enter a task',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.edit),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _addTodo,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Add Task'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: _todoList[index]['completed'],
                        onChanged: (bool? value) {
                          _toggleTodoCompletion(index);
                        },
                      ),
                      title: Text(
                        _todoList[index]['task'],
                        style: TextStyle(
                          fontSize: 18,
                          decoration: _todoList[index]['completed']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteTodoItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
