import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/home_screen/home_screen.dart';
import 'user/profile_provider.dart';

enum AuthMode { signInWithEmail, createUserWithEmail }

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Stream<String> get onAuthStateChanged {
    return _auth.authStateChanges().map((User user) {
      _uid = user?.uid;
      return _uid;
    });
  }

  String get currentUser {
    return _uid;
  }

  Future<void> authenticate(
      String username, String password, AuthMode authMode) async {
    UserCredential result;
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

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await ProfileProvider().initProfile(authResult.user.uid);
    _uid = authResult.user.uid;
    notifyListeners();
    // Update the username
    //await updateUserName(name, authResult.user);
    return authResult.user.uid;
  }

  // Email & Password Sign In
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    _uid = result.user.uid;
    notifyListeners();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();
    _uid = null;
    //notifyListeners();
  }

  // Create Anonymous User
  Future singInAnonymously() {
    return _auth.signInAnonymously();
  }

  // GOOGLE
  Future<String> signInWithGoogle() async {
    GoogleSignInAccount account;
    try {
      account = await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }

    final GoogleSignInAuthentication _googleAuth = await account.authentication;

    final authHeaders = _googleSignIn.currentUser.authHeaders;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );

    var authResult = await _auth.signInWithCredential(credential);
    if (authResult.additionalUserInfo.isNewUser) {
      ProfileProvider().initProfile(authResult.user.uid);
    }

    return authResult.user.uid;
  }

  // APPLE
  Future signInWithApple() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential _appleAuth = result.credential;
        final OAuthProvider oAuthProvider = new OAuthProvider("apple.com");

        final AuthCredential credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(_appleAuth.identityToken),
          accessToken: String.fromCharCodes(_appleAuth.authorizationCode),
        );

        await _auth.signInWithCredential(credential);

        // update the user information
        if (_appleAuth.fullName != null) {
          _auth.currentUser.updateProfile(
              displayName:
                  "${_appleAuth.fullName.givenName} ${_appleAuth.fullName.familyName}");
        }

        break;

      case AuthorizationStatus.error:
        print("Sign In Failed ${result.error.localizedDescription}");
        break;

      case AuthorizationStatus.cancelled:
        print("User Cancled");
        break;
    }
  }

  Future updateUserName(String name, User currentUser) async {
    // var userUpdateInfo = UserUpdateInfo();
    // userUpdateInfo.displayName = name;
    await currentUser.updateProfile(displayName: name);
    await currentUser.reload();
  }

  Future createUserWithPhone(String phone, BuildContext context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          _auth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {
            ProfileProvider().initProfile(result.user.uid);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            ); // to pop the dialog box
            // Navigator.of(context).pushReplacementNamed('/home');
          }).catchError((e) {
            return "error";
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          return "error";
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          final _codeController = TextEditingController();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text("请输入验证码"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[TextField(controller: _codeController)],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("确认"),
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () {
                    var _credential = PhoneAuthProvider.credential(
                        verificationId: verificationId,
                        smsCode: _codeController.text.trim());
                    _auth
                        .signInWithCredential(_credential)
                        .then((UserCredential result) {
                      ProfileProvider().initProfile(result.user.uid);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      ); // to pop the dialog box
                      //Navigator.of(context).pushReplacementNamed('/home');
                    }).catchError((e) {
                      return "error";
                    });
                  },
                )
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        });
  }
}
