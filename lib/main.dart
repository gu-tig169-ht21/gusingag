import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Todoprovider.dart';

void main() => runApp(new TodoApp());

class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return TextStyle(
      fontFamily: 'RobotoCondensed',
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: CheckboxListTile(
          title: Text(todo.name, style: _getTextStyle(todo.checked)),
          value: todo.checked,
          onChanged: (newValue) {
            onTodoChanged(todo);
          },
          controlAffinity: ListTileControlAffinity.leading,
        ));
  }

  void setState(Null Function() param0) {}
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => new _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
        Icons.account_circle_outlined,
        size: 35,
        ),
        title: Text(
            'Att göra',
          style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 30),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                Provider.of<TodoProvider>(context, listen: false)
                    .setFilterBy(value);
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('Alla aktiviteter'), value: '1'),
              const PopupMenuItem(child: Text('Genomförda'), value: '2'),
              const PopupMenuItem(child: Text('Kvar att göra'), value: '3')
            ],
          )
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: _todos.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(),
          tooltip: 'Lägg till aktivitet',
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.add)),
    );
  }


  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Lägg till aktivitet',
            style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 25, color: Colors.deepPurple),
        ),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Skriv din aktivitet'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                  'Avbryt',
              style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 20, color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                  'Lägg till',
                style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 20, color: Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            )
          ],
        );
      },
    );
  }
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Att göra idag',
      home: new TodoList(),
    );
  }
}
