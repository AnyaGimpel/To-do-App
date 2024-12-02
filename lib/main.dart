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


void setupLocator(){
  GetIt.instance.registerLazySingleton<AuthService>(() => AuthService());
  GetIt.instance.registerLazySingleton<TaskService>(() => TaskService());
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
        ),

        BlocProvider<TaskCubit>(
          create: (_) => TaskCubit(GetIt.instance<TaskService>()),
        ),

      ],
      child: const MyApp(), 
    ),
  );
}




