import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/auth_provider.dart';
import '../../configurations/theme.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.signInWithEmail;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierColor: Color.fromARGB(1, 255, 255, 255),
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false).authenticate(
          _authData['email'].trim(), _authData['password'], _authMode);
    } on PlatformException catch (error) {
      _showErrorDialog(error.message);
    } catch (error) {
      const errorMessage = '无法正常登陆，请稍后再试';
      _showErrorDialog(errorMessage);
    }
    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<dynamic> _reset() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .sendPasswordResetEmail(_authData['email'].trim());
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
                child: AlertDialog(
              content: Container(
                  height: 100,
                  width: 100,
                  child: Text(
                    "密码重置邮件已发送至 $_authData['email']",
                    style: Theme.of(context).textTheme.captionMedium4,
                  )),
            ));
          });
    } on PlatformException catch (error) {
      _showErrorDialog(error.message);
    } catch (error) {
      const errorMessage = '重置密码出错，稍后再试';
      _showErrorDialog(errorMessage);
    }

    // if (this.mounted) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.createUserWithEmail) {
      setState(() {
        _authMode = AuthMode.signInWithEmail;
      });
    } else {
      setState(() {
        _authMode = AuthMode.createUserWithEmail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Title(
                  color: Colors.black,
                  child: Text(
                    _authMode == AuthMode.signInWithEmail ? '电子邮箱登陆' : '电子邮箱注册',
                    style: Theme.of(context).textTheme.headline3,
                  )),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(300, 25)),
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                        helperText: "邮箱",
                        helperStyle: Theme.of(context).textTheme.captionMedium4,
                        hintText: '请输入邮箱地址',
                        hintStyle: Theme.of(context).textTheme.captionMedium3),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                    onChanged: (value) {
                      _authData['email'] = value;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(300, 25)),
                  child: TextFormField(
                    decoration: InputDecoration(
                        helperText: "密码",
                        helperStyle: Theme.of(context).textTheme.captionMedium4,
                        hintText: '请输入密码',
                        hintStyle: Theme.of(context).textTheme.captionMedium3),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return '密码长度不对！';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                ),
              ),
              if (_authMode == AuthMode.createUserWithEmail)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tight(Size(300, 25)),
                    child: TextFormField(
                      enabled: _authMode == AuthMode.createUserWithEmail,
                      decoration: InputDecoration(
                          helperText: "再次输入密码",
                          helperStyle:
                              Theme.of(context).textTheme.captionMedium4,
                          hintText: '请再次输入密码',
                          hintStyle:
                              Theme.of(context).textTheme.captionMedium3),
                      obscureText: true,
                      validator: _authMode == AuthMode.createUserWithEmail
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                FlatButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      '忘记密码',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'LantingXianHei',
                      ),
                    ),
                  ),
                  onPressed: () {
                    _reset();
                    // Dialog(
                    //   child: Text("testing"),
                    // );
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Colors.grey[100],
                ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "点击按钮表示您同意并遵守随行",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'LantingXianHei',
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Text("《使用协议》",
                            style: TextStyle(
                              fontFamily: 'LantingXianHei',
                              fontSize: 10,
                              color: Theme.of(context).accentColor,
                            )),
                        onTap: () async {
                          if (await canLaunch("https://www.google.com")) {
                            await launch("https://www.google.com");
                          }
                        },
                      ),
                      Text(
                        "和",
                        style: TextStyle(
                          fontFamily: 'LantingXianHei',
                          fontSize: 10,
                        ),
                      ),
                      InkWell(
                        child: Text("《隐私协议》",
                            style: TextStyle(
                              fontFamily: 'LantingXianHei',
                              fontSize: 10,
                              color: Theme.of(context).accentColor,
                            )),
                        onTap: () async {
                          if (await canLaunch("https://www.google.com")) {
                            await launch("https://www.google.com");
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: Text(
                    _authMode == AuthMode.signInWithEmail ? '登陆' : '注册',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'LantingXianHei',
                        color: Colors.white),
                  ),
                ),
                onPressed: _submit,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                color: Colors.lightBlue,
                textColor: Theme.of(context).primaryTextTheme.button.color,
              ),
              SizedBox(height: 10.0),
              FlatButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    '${_authMode == AuthMode.signInWithEmail ? '注册新邮箱' : '使用邮箱登陆'}',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'LantingXianHei',
                    ),
                  ),
                ),
                onPressed: _switchAuthMode,
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: Colors.grey[100],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
