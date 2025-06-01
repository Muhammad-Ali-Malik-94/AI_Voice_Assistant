import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      // Update last login and check for other active sessions
      if (result.user != null) {
        await _updateUserSession(result.user!.uid);
      }
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> _updateUserSession(String userId) async {
    // Get user's current sessions
    final userDoc = _db.collection('users').doc(userId);

    await userDoc.set({
      'lastActive': FieldValue.serverTimestamp(),
      'deviceToken': await _getDeviceToken(), // Implement this based on your needs
      'lastLoginTime': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String> _getDeviceToken() async {
    // Implement device token generation
    // This could be a unique identifier for the device
    return DateTime.now().toIso8601String();
  }

  Future<void> signOut() async {
    if (currentUser != null) {
      await _db.collection('users').doc(currentUser!.uid).update({
        'deviceToken': FieldValue.delete(),
      });
    }
    await _auth.signOut();
  }

  String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'invalid-email':
          return 'The email address is badly formatted.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        default:
          return 'Authentication failed. Please try again.';
      }
    }
    return 'An unexpected error occurred.';
  }
}