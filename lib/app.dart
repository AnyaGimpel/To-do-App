import 'package:flutter/material.dart';
import 'package:todo_app/ui/screens/login_page.dart';

/// The main application widget for the To-do App.
/// 
/// This class sets up the global theme and the entry point to the app's UI, 
/// which initially navigates to the login page.
class MyApp extends StatelessWidget {
  /// A constant constructor for `MyApp`.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do App',

      // Defines the global theme for the application.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
          backgroundColor: Colors.white,
        ),
      ),

      // Sets the initial screen to the login page.
      home: LoginPage(),
    );
  }
}
