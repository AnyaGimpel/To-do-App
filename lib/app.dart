import 'package:flutter/material.dart';
import 'package:todo_app/ui/screens/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
              //fontWeight: FontWeight.bold, 
              color: Colors.black, 
              fontSize: 24
          ),
          backgroundColor: Colors.white
        ),
      ), 
      home: LoginPage(),
    );
  }
}