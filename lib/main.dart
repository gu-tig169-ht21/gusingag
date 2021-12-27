import 'package:flutter/material.dart';
import 'providers/todos_provider.dart';
import 'package:provider/provider.dart';
import 'views/home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ip = TodosProvider();
    ip.getName();
    return ChangeNotifierProvider(
        create: (context) => ip,
        child: MaterialApp(
            title: 'Att göra idag',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Home()));
  }
}


