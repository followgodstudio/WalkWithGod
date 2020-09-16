import 'package:auto_size_text/auto_size_text.dart';
import 'package:apple_sign_in/apple_sign_in.dart' as apple;
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:provider/provider.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../home_screen/home_screen.dart';
import '../../providers/auth_provider.dart';
import '../../utils/utils.dart';
import '../../configurations/theme.dart';

enum AuthFormType { signIn, signUp, reset, anonymous, phone }

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  final AuthFormType authFormType;

  SignupScreen({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignupScreenState createState() =>
      _SignupScreenState(authFormType: this.authFormType);
}

class _SignupScreenState extends State<SignupScreen> {
  AuthFormType authFormType;
  bool _showAppleSignIn = false;

  @override
  void initState() {
    super.initState();
    _useAppleSignIn();
  }

  _useAppleSignIn() async {
    final isAvailable = await apple.AppleSignIn.isAvailable();
    setState(() {
      _showAppleSignIn = isAvailable;
    });
  }

  _SignupScreenState({this.authFormType});
  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning, _phone;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == 'home') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    if (authFormType == AuthFormType.anonymous) {
      return true;
    }
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        switch (authFormType) {
          case AuthFormType.signIn:
            await auth.signInWithEmailAndPassword(_email, _password);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case AuthFormType.signUp:
            await auth.createUserWithEmailAndPassword(_email, _password, _name);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case AuthFormType.reset:
            await auth.sendPasswordResetEmail(_email);
            setState(() {
              _warning = "密码重置邮件已发送到：$_email";
              authFormType = AuthFormType.signIn;
            });
            break;
          case AuthFormType.anonymous:
            await auth.singInAnonymously();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case AuthFormType.phone:
            var result = await auth.createUserWithPhone(_phone, context);
            if (_phone == "" || result == "error") {
              setState(() {
                _warning = "Your phone number could not be validated";
              });
            }
            break;
        }
      } catch (e) {
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    if (authFormType == AuthFormType.anonymous) {
      submit();
      return Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitDoubleBounce(
                  color: Colors.black,
                ),
                Text(
                  "Loading",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ));
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // color: Theme.of(context).canvasColor,
            color: Theme.of(context).canvasColor,
            height: _height,
            width: _width,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(height: _height * 0.025),
                  showAlert(),
                  SizedBox(height: _height * 0.025),
                  buildHeaderText(),
                  SizedBox(height: _height * 0.05),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: buildInputs() + buildButtons(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "电子邮箱登陆";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "找回密码";
    } else if (authFormType == AuthFormType.phone) {
      _headerText = "手机号码登录";
    } else {
      _headerText = "注册新邮箱";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline3,
    );
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phone = internationalizedPhoneNumber;
    });
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    // add email & password
    if ([AuthFormType.signUp, AuthFormType.reset, AuthFormType.signIn]
        .contains(authFormType)) {
      textFields.add(
        TextFormField(
          validator: EmailValidator.validate,
          style: Theme.of(context).textTheme.bodyText1,
          decoration: buildSignUpInputDecoration("请输入邮箱地址"),
          onSaved: (value) => _email = value,
        ),
      );
      textFields.add(SizedBox(height: 20));
    }

    if (authFormType != AuthFormType.reset &&
        authFormType != AuthFormType.phone) {
      textFields.add(
        TextFormField(
          validator: PasswordValidator.validate,
          style: Theme.of(context).textTheme.bodyText1,
          decoration: buildSignUpInputDecoration("请输入密码"),
          obscureText: true,
          keyboardType: TextInputType.emailAddress,
          onSaved: (value) => _password = value,
        ),
      );
      textFields.add(SizedBox(height: 20));
    }

    if (authFormType == AuthFormType.phone) {
      textFields.add(
        InternationalPhoneInput(
            decoration: buildSignUpInputDecoration("请输入手机号码"),
            onPhoneNumberChange: onPhoneNumberChange,
            initialPhoneNumber: _phone,
            initialSelection: 'US',
            showCountryCodes: true),
      );
      textFields.add(SizedBox(height: 20));
    }

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding: const EdgeInsets.only(
        left: 14.0,
        bottom: 10.0,
        top: 10.0,
      ),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "注册新邮箱";
      _newFormState = "signUp";
      _submitButtonText = "登陆";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "使用邮箱登陆";
      _newFormState = "signIn";
      _submitButtonText = "发送链接";
      _showSocial = false;
    } else if (authFormType == AuthFormType.phone) {
      _switchButtonText = "使用邮箱登陆";
      _newFormState = "signIn";
      _submitButtonText = "获取验证码";
      _showSocial = false;
    } else {
      _switchButtonText = "使用邮箱登陆";
      _newFormState = "signIn";
      _submitButtonText = "确认信息并注册";
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: FlatButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'LantingXianHei',
                  color: Colors.white),
            ),
          ),
          onPressed: submit,
          color: Colors.lightBlue,
          textColor: Theme.of(context).primaryTextTheme.button.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      showForgotPassword(_showForgotPassword),
      SizedBox(
        height: 10,
      ),
      FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.grey[100],
        textColor: Theme.of(context).accentColor,
        child: Text(
          _switchButtonText,
          style: TextStyle(
            fontSize: 14.0,
            fontFamily: 'LantingXianHei',
          ),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      ),
      buildSocialIcons(_showSocial),
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: Column(
        children: [
          SizedBox(height: 15.0),
          FlatButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                "忘记密码?",
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'LantingXianHei',
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                authFormType = AuthFormType.reset;
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.grey[100],
          ),
          SizedBox(height: 15.0),
        ],
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of<AuthProvider>(context, listen: false);
    return Visibility(
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Divider(
                color: Colors.white,
              ),
              SizedBox(height: 10),
              buildAppleSignIn(_auth),
              SizedBox(height: 10),
              GoogleSignInButton(
                centered: true,
                text: "Google账号登陆",
                textStyle: Theme.of(context).textTheme.captionSmall3,
                onPressed: () async {
                  try {
                    await _auth.signInWithGoogle();
                    // Navigator.of(context).pushReplacementNamed('/home');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } catch (e) {
                    setState(() {
                      _warning = e.message + "。请使用其他方式登陆";
                    });
                  }
                },
              ),
              RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.phone),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 14.0, top: 10.0, bottom: 10.0),
                      child: Text("使用手机号码登陆", style: TextStyle(fontSize: 18)),
                    )
                  ],
                ),
                onPressed: () {
                  setState(() {
                    authFormType = AuthFormType.phone;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ]),
      visible: visible,
    );
  }

  Widget buildAppleSignIn(_auth) {
    final _auth = Provider.of<AuthProvider>(context, listen: false);
    if (_showAppleSignIn == true) {
      return apple.AppleSignInButton(
        onPressed: () async {
          await _auth.signInWithApple();
          //Navigator.of(context).pushReplacementNamed('/home');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        style: apple.ButtonStyle.black,
      );
    } else {
      return Container();
    }
  }
}
