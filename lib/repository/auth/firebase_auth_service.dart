import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  static final FirebaseAuthService instance = FirebaseAuthService._();
  FirebaseAuthService._();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool get isGoogleUser =>
      _auth.currentUser?.providerData.any(
        (p) => p.providerId == 'google.com',
      ) ??
      false;

  Future<User?> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await result.user?.updateDisplayName(displayName);
    return result.user;
  }

  Future<User?> signInWithGoogle() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      throw UnsupportedError(
        'Google Sign-In no está disponible en Windows desktop',
      );
    }
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  Future<void> reauthenticateWithPassword(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(code: 'user-not-found');
    }
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  Future<void> updatePassword(String newPassword) async {
    await _auth.currentUser?.updatePassword(newPassword);
  }

  static String mapError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Credenciales incorrectas';
        case 'email-already-in-use':
          return 'El correo ya está registrado';
        case 'weak-password':
          return 'La contraseña debe tener al menos 6 caracteres';
        case 'invalid-email':
          return 'Correo electrónico inválido';
        case 'network-request-failed':
          return 'Error de conexión. Verifica tu internet';
        case 'too-many-requests':
          return 'Demasiados intentos. Intenta más tarde';
        case 'requires-recent-login':
          return 'Inicia sesión nuevamente para realizar esta acción';
        default:
          return 'Error de autenticación. Intenta nuevamente';
      }
    }
    if (error is UnsupportedError) return error.message ?? error.toString();
    return 'Error inesperado. Intenta nuevamente';
  }
}
