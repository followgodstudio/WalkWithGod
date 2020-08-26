import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

enum AuthMode { signInWithEmail, createUserWithEmail }

class Auth with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid;

  Stream<String> get onAuthStateChanged {
    return _auth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);
  }

  String get currentUser {
    return _uid;
  }

  Future<void> authenticate(
      String username, String password, AuthMode authMode) async {
    AuthResult result;
    if (authMode == AuthMode.createUserWithEmail) {
      result = await _auth.createUserWithEmailAndPassword(
          email: username, password: password);
    } else if (authMode == AuthMode.signInWithEmail) {
      result = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
    }
    _uid = result.user.uid;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _uid = null;
    notifyListeners();
  }
}
