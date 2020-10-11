import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/home_screen/home_screen.dart';
import '../utils/my_logger.dart';
import 'user/profile_provider.dart';

class AuthProvider with ChangeNotifier {
  StreamSubscription userAuthSub;
  FirebaseAuth _auth = FirebaseAuth.instance;
  MyLogger _logger = MyLogger("Provider");
  String _userId;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  AuthProvider() {
    userAuthSub = _auth.authStateChanges().listen((newUser) {
      String newUserId = (newUser != null) ? newUser.uid : null;
      if (newUserId == _userId) return;
      _userId = newUserId;
      _logger.i("AuthProvider-init-onAuthStateChanged-$_userId");
      notifyListeners();
    });
  }

  @override
  void dispose() {
    if (userAuthSub != null) {
      userAuthSub.cancel();
      userAuthSub = null;
    }
    super.dispose();
  }

  String get userId {
    return _userId;
  }

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await ProfileProvider(authResult.user.uid).initProfile();
    _userId = authResult.user.uid;
    notifyListeners();
    // Update the username
    return authResult.user.uid;
  }

  // Email & Password Sign In
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    _userId = result.user.uid;
    notifyListeners();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    await _auth.signOut();
    _userId = null;
    //notifyListeners();
  }

  // GOOGLE
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );

    var authResult = await _auth.signInWithCredential(credential);
    if (authResult.additionalUserInfo.isNewUser) {
      await ProfileProvider(authResult.user.uid).initProfile();
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
        _logger.e(
            "AuthProvider-signInWithApple-Sign In Failed ${result.error.localizedDescription}");
        break;

      case AuthorizationStatus.cancelled:
        _logger.i("AuthProvider-signInWithApple-User Cancled");
        break;
    }
  }

  Future updateUserName(String name, User currentUser) async {
    // var userUpdateInfo = UserUpdateInfo();
    // userUpdateInfo.displayName = name;
    await currentUser.updateProfile(displayName: name);
    await currentUser.reload();
  }

  Future<void> createUserWithPhone(String phone, BuildContext context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          _logger.i("AuthProvider-createUserWithPhone-Verification completed");
          UserCredential result =
              await _auth.signInWithCredential(authCredential);
          User user = result.user;
          _routeHome(context);

          if (user != null) {
            _routeHome(context);
          } else {
            _logger.i("AuthProvider-createUserWithPhone-Error");
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          _logger.e("AuthProvider-createUserWithPhone-Verification failed: " +
              exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          final _codeController = TextEditingController();
          _logger.i(
              "AuthProvider-createUserWithPhone-Code sent: " + verificationId);
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
                      if (result.additionalUserInfo.isNewUser) {
                        ProfileProvider(result.user.uid).initProfile();
                      }
                      _routeHome(context);
                    });
                  },
                )
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          _logger.e("AuthProvider-createUserWithPhone-Send code time out");
        });
  }

  Future<void> deleteUser() async {
    await ProfileProvider(_userId).deleteProfile();
    await _auth.currentUser.delete();
    _userId = null;
  }

  void _routeHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName, (Route<dynamic> route) => false);
  }
}
