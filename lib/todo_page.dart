import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'theme_provider.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> with SingleTickerProviderStateMixin {
  final TextEditingController _todoController = TextEditingController();
  List<Map<String, dynamic>> _todoList = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadTodoList();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _todoController.dispose();
    _animationController.dispose();
    super.dispose();
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
    if (_todoController.text.isNotEmpty) {
      setState(() {
        _todoList.add({'task': _todoController.text, 'completed': false});
        _animationController.forward(from: 0.0);
      });
      _todoController.clear();
      _saveTodoList();
    }
  }

  // 할 일 삭제하기
  void _deleteTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
    });
    _saveTodoList();
  }

  // 할 일 완료 상태 변경하기
  void _toggleTodoCompletion(int index) {
    setState(() {
      _todoList[index]['completed'] = !_todoList[index]['completed'];
      _saveTodoList();
    });
  }

  Widget _buildTodoItem(Map<String, dynamic> todo, int index) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: Checkbox(
            value: todo['completed'],
            onChanged: (bool? value) {
              _toggleTodoCompletion(index);
            },
          ),
          title: Text(
            todo['task'],
            style: TextStyle(
              fontSize: 18,
              decoration: todo['completed'] ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _deleteTodoItem(index),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  return _buildTodoItem(_todoList[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
