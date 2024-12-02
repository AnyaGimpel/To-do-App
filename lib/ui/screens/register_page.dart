import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/auth_cubit.dart';
import 'package:todo_app/ui/screens/home_page.dart';
import 'package:todo_app/ui/screens/login_page.dart';

/// RegisterPage widget that handles user registration
class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        automaticallyImplyLeading: false, 
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // Handle authentication state changes
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthAuthenticated) {
            // Navigate to home page after successful registration
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },
        builder: (context, state) {
          // Show a loading spinner while registering
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(  
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),  
                child: Column(
                  children: [
                    // Email input field
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    // Password input field
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,  // Hide password text
                    ),
                    // Repeat password input field
                    TextField(
                      controller: passwordRepeatController,
                      decoration: InputDecoration(labelText: 'Repeat password'),
                      obscureText: true,  
                    ),
                    SizedBox(height: 20), 
                    // Register button
                    ElevatedButton(
                      onPressed: () {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final repeatPassword = passwordRepeatController.text.trim();

                        // Validate the input fields
                        final error = _validateFields(email, password, repeatPassword);
                        if (error != null) {
                          if (context.mounted) {
                            _showSnackbar(context, error); // Show error message
                          }
                          return;
                        }

                        // Trigger registration
                        context.read<AuthCubit>().register(email, password);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, 
                        foregroundColor: Colors.white, 
                      ),
                      child: Text('Register'),
                    ),
                    SizedBox(height: 20), 
                    // Link to login page if user already has an account
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
              ),
            ),
          );
        },
      ),
    );
  }

  /// Validates the email, password, and repeat password fields
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
    return null; 
  }

  /// Shows a snackbar with the given message
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message))); 
  }
}
