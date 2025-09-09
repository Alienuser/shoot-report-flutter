import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  static User? get currentUser => _auth.currentUser;
  static String? get userId => _auth.currentUser?.uid;
  
  static Future<void> signInAnonymously() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }

  static Future<void> createAccountAndMigrateData(String email, String password) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || !currentUser.isAnonymous) {
      throw Exception('No anonymous user to upgrade');
    }

    // Create email/password credential
    final credential = EmailAuthProvider.credential(email: email, password: password);
    
    // Link anonymous account with email/password
    await currentUser.linkWithCredential(credential);
    
    // Data is automatically preserved since we're upgrading the same user
  }
}