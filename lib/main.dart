import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/services/task_service.dart';
import 'core/firebase_options.dart';
import 'app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/auth_cubit.dart';
import 'cubit/task_cubit.dart';
import 'services/auth_service.dart';
import 'package:get_it/get_it.dart';

/// Configures the service locator for dependency injection.
/// The GetIt package is used to manage dependencies in the app.
void setupLocator() {
  /// Registers `AuthService` as a lazy singleton.
  GetIt.instance.registerLazySingleton<AuthService>(() => AuthService());

  /// Registers `TaskService` as a lazy singleton.
  GetIt.instance.registerLazySingleton<TaskService>(() => TaskService());
}

/// The main entry point of the application.
void main() async {
  /// Ensures Flutter's widgets framework is initialized before executing async operations.
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializes Firebase for the app with platform-specific options.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Sets up the service locator.
  setupLocator();

  /// Runs the app with the necessary Bloc providers for state management.
  runApp(
    MultiBlocProvider(
      providers: [
        /// Provides `AuthCubit` for managing authentication state.
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
        ),

        /// Provides `TaskCubit` for managing task-related state.
        BlocProvider<TaskCubit>(
          create: (_) => TaskCubit(GetIt.instance<TaskService>()),
        ),
      ],
      /// Initializes the main application widget.
      child: const MyApp(),
    ),
  );
}
