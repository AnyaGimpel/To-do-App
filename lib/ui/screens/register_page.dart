import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/auth_cubit.dart';
import 'package:todo_app/ui/screens/home_page.dart';
import 'package:todo_app/ui/screens/login_page.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            // Показываем SnackBar с сообщением об ошибке
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthAuthenticated) {
            // Если пользователь успешно зарегистрирован, переходим на домашнюю страницу
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            // Показываем индикатор загрузки, если идет процесс регистрации
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextField(
                  controller: passwordRepeatController,
                  decoration: InputDecoration(labelText: 'Repeat password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final repeatPassword = passwordRepeatController.text.trim();

                    // Проверка полей
                    final error = _validateFields(email, password, repeatPassword);
                    if (error != null) {
                      if (context.mounted) {
                        _showSnackbar(context, error);
                      }
                      return;
                    }

                    // Вызываем метод регистрации из AuthCubit
                    context.read<AuthCubit>().register(email, password);
                  },
                  child: Text('Register'),
                ),
                TextButton(
                  onPressed: () => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    )
                  },
                  child: Text('Already have an account? Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String? _validateFields(
      String email, String password, String repeatPassword) {
    if (email.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      return 'All fields must be completed';
    }
    if (password.length < 6) {
      return 'The password must be at least 6 characters';
    }
    if (password != repeatPassword) {
      return 'Passwords do not match';
    }
    return null; // Нет ошибок
  }

  /// Показ сообщения пользователю
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
