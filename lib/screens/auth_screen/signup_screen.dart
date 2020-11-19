import 'package:apple_sign_in/apple_sign_in.dart' as apple;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../configurations/theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/my_logger.dart';
import '../../utils/utils.dart';
import '../../widgets/my_icon_button.dart';
import '../../widgets/my_text_button.dart';
import '../home_screen/home_screen.dart';
import 'country_code_select.dart';

enum AuthFormType { signIn, signUp, reset, phone }

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  final AuthFormType authFormType;

  SignupScreen({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignupScreenState createState() =>
      _SignupScreenState(authFormType: this.authFormType);
}

class _SignupScreenState extends State<SignupScreen> {
  _SignupScreenState({this.authFormType});
  final formKey = GlobalKey<FormState>();
  String _email, _password, _name;
  AuthFormType authFormType;
  bool _showAppleSignIn = false;
  String countryCode = "+1";
  String phoneNumber = "";

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

  void routeHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName, (Route<dynamic> route) => false);
  }

  void switchFormState(String state) {
    formKey.currentState.reset();
    AuthFormType newType = AuthFormType.values
        .firstWhere((e) => e.toString() == "AuthFormType." + state, orElse: () {
      return null;
    });
    if (newType != null)
      setState(() {
        authFormType = newType;
      });
  }

  bool validate() {
    final form = formKey.currentState;
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
      await exceptionHandling(context, () async {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        switch (authFormType) {
          case AuthFormType.signIn:
            await auth.signInWithEmailAndPassword(_email, _password);
            routeHome();
            break;
          case AuthFormType.signUp:
            await auth.createUserWithEmailAndPassword(_email, _password, _name);
            routeHome();
            break;
          case AuthFormType.reset:
            await auth.sendPasswordResetEmail(_email);
            showPopUpDialog(context, true, "密码重置邮件已发送到：$_email");
            break;
          case AuthFormType.phone:
            String _phone = countryCode + phoneNumber;
            MyLogger("Widget").i("SignupScreen-submit-" + _phone);
            await auth.createUserWithPhone(_phone, context);
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).canvasColor,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: Column(
                children: <Widget>[
                  buildHeaderText(),
                  SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: buildInputs() + buildButtons(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signIn) {
      _headerText = "电子邮箱登录";
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
      style: Theme.of(context).textTheme.headline2,
    );
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
      Widget phoneWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlatButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => CountryCodeSelect((newCode) {
                          setState(() {
                            this.countryCode = newCode;
                          });
                        }));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(this.countryCode,
                      style: Theme.of(context).textTheme.bodyText1),
                  Icon(Icons.arrow_drop_down),
                ],
              )),
          Expanded(
            child: Container(
              height: 50,
              child: TextFormField(
                style: Theme.of(context).textTheme.bodyText1,
                decoration: buildSignUpInputDecoration("请输入手机号码"),
                keyboardType: TextInputType.number,
                onSaved: (value) => phoneNumber = value,
              ),
            ),
          ),
        ],
      );
      textFields.add(phoneWidget);
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

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "注册新邮箱";
      _newFormState = "signUp";
      _submitButtonText = "登录";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "使用邮箱登录";
      _newFormState = "signIn";
      _submitButtonText = "发送链接";
    } else if (authFormType == AuthFormType.phone) {
      _submitButtonText = "获取验证码";
    } else {
      _switchButtonText = "使用邮箱登录";
      _newFormState = "signIn";
      _submitButtonText = "确认信息并注册";
    }

    return [
      SizedBox(height: 10.0),
      MyTextButton(
        width: double.infinity,
        text: _submitButtonText,
        style: TextButtonStyle.active,
        onPressed: submit,
      ),
      SizedBox(height: 10.0),
      forgotPasswordButton(_showForgotPassword),
      SizedBox(height: 10.0),
      switchEmailStateButton(_switchButtonText, _newFormState),
      SizedBox(height: 10.0),
      Divider(),
      SizedBox(height: 10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_showAppleSignIn)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: buildSwitchButton("apple"),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: buildSwitchButton("google"),
          ),
          if (authFormType != AuthFormType.phone)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: buildSwitchButton("phone"),
            ),
          if (authFormType != AuthFormType.signIn)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: buildSwitchButton("email"),
            ),
        ],
      ),
    ];
  }

  Widget switchEmailStateButton(String switchButtonText, String newFormState) {
    return Visibility(
      child: MyTextButton(
        text: switchButtonText,
        width: 100,
        isSmall: true,
        textColor: MyColors.lightBlue,
        onPressed: () {
          switchFormState(newFormState);
        },
      ),
      visible: switchButtonText != null,
    );
  }

  Widget forgotPasswordButton(bool visible) {
    return Visibility(
      child: Column(
        children: [
          SizedBox(height: 15.0),
          MyTextButton(
            text: "忘记密码",
            width: 100,
            isSmall: true,
            textColor: MyColors.error,
            onPressed: () {
              setState(() {
                authFormType = AuthFormType.reset;
              });
            },
          ),
          SizedBox(height: 15.0),
        ],
      ),
      visible: visible,
    );
  }

  Widget buildSwitchButton(String target) {
    final _auth = Provider.of<AuthProvider>(context, listen: false);
    return MyIconButton(
      icon: target,
      iconColor: MyColors.black,
      hasBorder: true,
      buttonSize: 50.0,
      onPressed: () {
        if (target == "phone") switchFormState(target);
        if (target == "email") switchFormState("signIn");
        if (target == "google")
          exceptionHandling(context, () async {
            await _auth.signInWithGoogle();
            routeHome();
          });
        if (target == "apple")
          exceptionHandling(context, () async {
            await _auth.signInWithApple();
            routeHome();
          });
      },
    );
  }
}
