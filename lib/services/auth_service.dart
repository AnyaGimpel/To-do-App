import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
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

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
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

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
