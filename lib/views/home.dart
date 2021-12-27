import 'package:flutter/material.dart';
import 'package:my_first_app/providers/todos_provider.dart';
import 'package:my_first_app/todo.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/views/add_todo.dart';

class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool checkAll = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
              appBar: AppBar(
                leading: const Icon(
                  Icons.account_circle_outlined,
                  size: 35,
                ),
                title: const Text(
                  'Att göra',
                  style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 30),
                ),
                actions: <Widget>[
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      setState(() {
                        Provider.of<TodosProvider>(context, listen: false)
                            .setFilterBy(value);
                      });
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          child: Text('Alla aktiviteter'), value: '1'),
                      const PopupMenuItem(
                          child: Text('Genomförda'), value: '2'),
                      const PopupMenuItem(
                          child: Text('Kvar att göra'), value: '3')
                    ],
                  )
                ],
              ),
                body: Consumer<TodosProvider>(
                    builder: (context, TodosProvider data, child) {
                      return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: _filterList(data.list, data.filterBy)!
                          .map((card) =>
                          ListTodo(context, card)).toList()
                      );
                    }),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => AddTodo(),
                ));
          },

                tooltip: "Lägg till",
                child: const Icon(Icons.add),
              ));
        });
  }
}

Widget deleteButton(BuildContext context, todo, String name) {
  return IconButton(
    icon: const Icon(Icons.delete_outline),
    tooltip: "Delete",
    onPressed: () => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text("Är du säker på att du vill radera '$name'?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Avbryt'),
          ),
          TextButton(
            onPressed: () async {
              Provider.of<TodosProvider>(context, listen: false)
                  .removeTodo(todo);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ),
  );
}

class ListTodo extends StatefulWidget {
  final Todos todo;
  BuildContext context;
  ListTodo(this.context, this.todo, {Key? key}) : super(key: key);

  @override
  State<ListTodo> createState() => _ListTodoState();
}

class _ListTodoState extends State<ListTodo> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
              padding: const EdgeInsets.all(2),
              child: CheckboxListTile(
                  value: widget.todo.done,
                  title: Text(
                    widget.todo.title,
                    style: (TextStyle(
                        decoration: widget.todo.done ? TextDecoration.lineThrough : null,
                        decorationThickness: 2)),
                  ),
                  secondary: deleteButton(context, widget.todo, widget.todo.title),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.deepPurple,
                  onChanged: (newvalue) async {
                    setState ((){
                      Provider.of<TodosProvider>(context, listen: false)
                          .updateTodo(widget.todo, newvalue!);
                    });
                  }));
        });
  }
}

List<Todos>? _filterList(List<Todos> list, filterBy) {
  if (filterBy == '1') return list;
  if (filterBy == '2') {
    return list.where((_todos) => _todos.done == true).toList();
  }
  if (filterBy == '3') {
    return list.where((_todos) => _todos.done == false).toList();
  }
  return list;
}










