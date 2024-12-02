import 'package:firebase_auth/firebase_auth.dart';

/// Service class to handle authentication logic with Firebase.
class AuthService {
  /// Instance of FirebaseAuth for interacting with Firebase authentication.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Registers a user using email and password.
  ///
  /// Throws specific errors based on [FirebaseAuthException] codes.
  /// 
  /// Returns a [User] object on successful registration.
  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Returning the registered user.
    } on FirebaseAuthException catch (e) {
      // Handling specific FirebaseAuth errors.
      switch (e.code) {
        case 'email-already-in-use':
          throw 'This email has already been registered';
        case 'invalid-email':
          throw 'Incorrect email format';
        case 'operation-not-allowed':
          throw 'Registration is disabled, please try again later';
        case 'network-request-failed':
          throw 'No internet connection. Please check your network and try again.';
        default:
          throw 'Error during registration: ${e.message}';
      }
    }
  }

  /// Logs in a user using email and password.
  ///
  /// Throws specific errors based on [FirebaseAuthException] codes.
  /// 
  /// Returns a [User] object on successful login.
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Returning the logged-in user.
    } on FirebaseAuthException catch (e) {
      // Handling specific FirebaseAuth errors.
      switch (e.code) {
        case 'user-not-found':
          throw 'This user is not registered';
        case 'invalid-email':
          throw 'Incorrect email format';
        case 'invalid-credential':
          throw 'Incorrect email or password';
        case 'network-request-failed':
          throw 'No internet connection. Please check your network and try again.';
        default:
          throw 'Error during login: ${e.message}';
      }
    }
  }

  /// Logs out the currently authenticated user.
  Future<void> logout() async {
    await _firebaseAuth.signOut(); // Signing out the user.
  }

  /// Stream that emits the current authentication state.
  ///
  /// Emits a [User] object when a user is logged in and `null` when logged out.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
