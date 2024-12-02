import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import '../services/auth_service.dart';

/// The `AuthCubit` handles authentication-related logic for the app.
///
/// It provides methods to register, log in, and log out users, monitor
/// authentication state changes. This class interacts with the `AuthService` to perform
/// Firebase authentication operations and emits various `AuthState` changes.
class AuthCubit extends Cubit<AuthState> {
  /// The instance of `AuthService` retrieved via dependency injection.
  final AuthService _authService = GetIt.instance<AuthService>();

  /// Constructs an `AuthCubit` with an initial state of `AuthInitial`.
  AuthCubit() : super(AuthInitial());

  /// Registers a user with the given [email] and [password].
  ///
  /// Emits [AuthLoading] during the process, [AuthAuthenticated] on success,
  /// or [AuthError] if an error occurs.
  Future<void> register(String email, String password) async {
    emit(AuthLoading()); // Notify UI that authentication is in progress.
    try {
      final user = await _authService.register(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user)); // Registration successful.
      } else {
        emit(AuthError('Registration failed: User is null')); // User creation failed.
      }
    } catch (e) {
      emit(AuthError('$e')); // Emit an error state with the exception message.
    }
  }

  /// Logs in a user with the given [email] and [password].
  ///
  /// Emits [AuthLoading] during the process, [AuthAuthenticated] on success,
  /// or [AuthError] if login fails.
  Future<void> login(String email, String password) async {
    emit(AuthLoading()); // Notify UI that login is in progress.
    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user)); // Login successful.
      } else {
        emit(AuthError('Login failed: User is null')); // Login failed.
      }
    } catch (e) {
      emit(AuthError('$e')); // Emit an error state with the exception message.
    }
  }

  /// Logs out the currently authenticated user.
  ///
  /// Emits [AuthUnauthenticated] once the user is successfully logged out.
  Future<void> logout() async {
    await _authService.logout();
    emit(AuthUnauthenticated());
  }

  /// Monitors changes in the authentication state.
  ///
  /// Emits [AuthAuthenticated] when a user is logged in, and [AuthUnauthenticated] when no user is logged in.
  void monitorAuthState() {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user)); // User is logged in.
      } else {
        emit(AuthUnauthenticated()); // No user is logged in.
      }
    });
  }
}

/// The base class for all authentication-related states.
@immutable
abstract class AuthState {}

/// Represents the initial state before any authentication action has occurred.
class AuthInitial extends AuthState {}

/// Represents a loading state during authentication processes (e.g., login or registration).
class AuthLoading extends AuthState {}

/// Represents a state when a user is successfully authenticated.
///
/// Contains the authenticated [user].
class AuthAuthenticated extends AuthState {
  /// The authenticated user object.
  final User user;

  /// Constructs the `AuthAuthenticated` state with the given [user].
  AuthAuthenticated(this.user);
}

/// Represents a state when no user is authenticated.
class AuthUnauthenticated extends AuthState {}

/// Represents a state when an authentication error occurs.
///
/// Contains an error [message] describing the issue.
class AuthError extends AuthState {
  final String message;

  /// Constructs the `AuthError` state with the given [message].
  AuthError(this.message);
}
