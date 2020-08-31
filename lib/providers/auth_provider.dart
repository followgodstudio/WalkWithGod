import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'user/profile_provider.dart';

enum AuthMode { signInWithEmail, createUserWithEmail }

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid;

  Stream<String> get onAuthStateChanged {
    return _auth.onAuthStateChanged.map((FirebaseUser user) {
      _uid = user?.uid;
      return _uid;
    });
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
      await ProfileProvider().initProfile(result.user.uid);
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