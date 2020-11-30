import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../exceptions/my_exception.dart';
import '../screens/auth_screen/phone_verification_screen.dart';
import '../screens/home_screen/home_screen.dart';
import '../utils/my_logger.dart';
import '../utils/utils.dart';
import 'user/profile_provider.dart';

class AuthProvider with ChangeNotifier {
  StreamSubscription userAuthSub;
  FirebaseAuth _auth = FirebaseAuth.instance;
  MyLogger _logger = MyLogger("Provider");
  String _userId;
  int _forceResendingToken;
  String _verificationId;

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
        throw (MyException("登陆失败：${result.error.localizedDescription}"));
        break;

      case AuthorizationStatus.cancelled:
        _logger.i("AuthProvider-signInWithApple-User Cancled");
        break;
    }
  }

  Future<void> signInWithPhone(String phone, BuildContext context,
      [bool isResend = false]) async {
    try {
      await _auth.verifyPhoneNumber(
          forceResendingToken: _forceResendingToken,
          phoneNumber: phone,
          timeout: Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential authCredential) async {
            UserCredential result =
                await _auth.signInWithCredential(authCredential);
            User user = result.user;
            _routeHome(context);

            if (user != null) {
              _routeHome(context);
            } else {
              showPopUpDialog(context, false, "登陆失败: verificationCompleted");
            }
          },
          verificationFailed: (FirebaseAuthException exception) {
            String message = "短信验证失败: " + exception.message;
            if (exception.code == 'invalid-phone-number') {
              message = "无效的电话号码";
            } else if (exception.code == 'too-many-requests') {
              message = "您已在四个小时内给这个手机号发送过五次验证码，请稍后再试";
            }
            showPopUpDialog(context, false, message);
          },
          codeSent: (String verificationId, int forceResendingToken) {
            _forceResendingToken = forceResendingToken;
            _verificationId = verificationId;
            if (isResend) {
              showPopUpDialog(context, true, "验证码已重新发送");
            } else {
              Navigator.of(context).pushNamed(
                PhoneVerificationScreen.routeName,
                arguments: phone,
              );
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _logger.i("AuthProvider-signInWithPhone-codeAutoRetrievalTimeout");
          });
    } on PlatformException catch (error) {
      String message = error.message;
      throw (MyException(message));
    }
  }

  Future<void> verifyPhoneCode(BuildContext context, String smsCode) async {
    var _credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);
    try {
      UserCredential result = await _auth.signInWithCredential(_credential);
      if (result.additionalUserInfo.isNewUser) {
        ProfileProvider(result.user.uid).initProfile();
      }
      _routeHome(context);
    } on FirebaseAuthException catch (error) {
      String message = error.message;
      if (error.code == "invalid-verification-code") {
        message = "验证码错误";
      }
      throw (MyException(message));
    }
  }

  Future<void> deleteUser() async {
    await ProfileProvider(_userId).deleteProfile();
    await _auth.currentUser.delete();
    _userId = null;
  }

  Future updateUserName(String name, User currentUser) async {
    // var userUpdateInfo = UserUpdateInfo();
    // userUpdateInfo.displayName = name;
    await currentUser.updateProfile(displayName: name);
    await currentUser.reload();
  }

  void _routeHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName, (Route<dynamic> route) => false);
  }
}
