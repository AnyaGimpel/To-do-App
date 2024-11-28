import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import '../services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService = GetIt.instance<AuthService>();

  AuthCubit() : super(AuthInitial());

  Future<void> register(String email, String password) async {
    emit(AuthLoading());  // Показываем индикатор загрузки
    try {
      final user = await _authService.register(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user));  // Регистрация прошла успешно
      } else {
        emit(AuthError('Registration failed: User is null'));  // Если не удалось создать пользователя
      }
    } catch (e) {
      emit(AuthError('$e'));  // Если произошла ошибка
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());  // Показываем индикатор загрузки
    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user));  // Успешный вход
      } else {
        emit(AuthError('Login failed: User is null'));  // Если не найден пользователь
      }
    } catch (e) {
      emit(AuthError('$e'));  // Если произошла ошибка
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    emit(AuthUnauthenticated());
  }

  void monitorAuthState() {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));  // Если пользователь аутентифицирован
      } else {
        emit(AuthUnauthenticated());  // Если пользователь не аутентифицирован
      }
    });
  }
}

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);  // Состояние аутентифицированного пользователя
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);  // Состояние ошибки с сообщением
}
