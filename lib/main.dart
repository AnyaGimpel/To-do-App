import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/firebase_options.dart';
import 'app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/auth_cubit.dart';
import 'services/auth_service.dart';
import 'package:get_it/get_it.dart';


void setupLocator(){
  GetIt.instance.registerLazySingleton<AuthService>(() => AuthService());
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Загрузка конфигурации для текущей платформы
  );

  setupLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
        ),
      ],
      child: const MyApp(), 
    ),
  );
}




