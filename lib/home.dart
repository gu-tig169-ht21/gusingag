import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_first_app/Todosprovider.dart';
import 'package:my_first_app/todo.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final _controller = TextEditingController();
  bool checkAll = false;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
                    onSelected: (value) async {
                      setState(() {
                        Provider.of<TodosProvider>(context, listen: false)
                            .setFilterBy(value);
                      });
                    },
                    itemBuilder: (context) =>
                    [
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
              body: SingleChildScrollView(
                child: Consumer<TodosProvider>(
                    builder: (context, TodosProvider data, child) {
                      return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: _filterList(data.list, data.filterBy)!
                          .map((card)
                      =>
                          ListTodo(context, card)
                      )
                      .
                      toList
                      (
                      )
                      );
                    }),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _controller.clear();
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 5, 8, 300),
                              child: TextFormField(
                                onFieldSubmitted: (value) async {
                                  Provider.of<TodosProvider>(
                                      context, listen: false)
                                      .addTodo(_controller.text, false);
                                  Navigator.pop(context);
                                },
                                decoration: InputDecoration(
                                  suffix: IconButton(
                                    onPressed: _controller.clear,
                                    icon: const Icon(Icons.clear),
                                  ),
                                  border: const UnderlineInputBorder(),
                                  hintText: 'Lägg till aktivitet',
                                ),
                                controller: _controller,
                              ),
                            ),
                          ],
                        );
                      });
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
        title: const Text('Varning'),
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

class ListTodo extends StatelessWidget {
  final Todos todo;
  BuildContext context;
  ListTodo(this.context, this.todo);
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
              padding: const EdgeInsets.all(2),
              child: CheckboxListTile(
                  value: todo.done,
                  title: Text(
                    todo.title,
                    style: (TextStyle(
                        decoration: todo.done ? TextDecoration.lineThrough : null,
                        decorationThickness: 2)),
                  ),
                  secondary: deleteButton(context, todo, todo.title),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.deepPurple,
                  onChanged: (newvalue) async {
                    setState ((){
                      Provider.of<TodosProvider>(context, listen: false)
                          .updateTodo(todo, newvalue!);
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










