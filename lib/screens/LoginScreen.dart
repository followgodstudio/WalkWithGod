import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walk_with_god/screens/HomeScreen.dart';
import '../widgets/otp_input.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isCodeSent = false;
  String _currentUserPhoneNumber = "";
  int _resendCodeTimer = 20;
  PinDecoration _pinDecoration = BoxLooseDecoration(
      strokeColor: Colors.grey[300],
      solidColor: Colors.grey[300],
      hintText: '000000',
      hintTextStyle: TextStyle(color: Colors.grey[400], fontSize: 25));

  TextEditingController _pinEditingController = TextEditingController();

  final _phoneController = TextEditingController();

  final _codeController = TextEditingController();

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if (user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          user: user,
                        )));
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          setState(() {
            _isCodeSent = true;
          });
          // showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: Text("Give the code?"),
          //         content: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: <Widget>[
          //             TextField(
          //               controller: _codeController,
          //             ),
          //           ],
          //         ),
          //         actions: <Widget>[
          //           FlatButton(
          //             child: Text("Confirm"),
          //             textColor: Colors.white,
          //             color: Colors.blue,
          //             onPressed: () async {
          //               final code = _codeController.text.trim();
          //               AuthCredential credential =
          //                   PhoneAuthProvider.getCredential(
          //                       verificationId: verificationId, smsCode: code);

          //               AuthResult result =
          //                   await _auth.signInWithCredential(credential);

          //               FirebaseUser user = result.user;

          //               if (user != null) {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => HomeScreen(
          //                               user: user,
          //                             )));
          //               } else {
          //                 print("Error");
          //               }
          //             },
          //           )
          //         ],
          //       );
          //     });
        },
        codeAutoRetrievalTimeout: null);
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _updateCurrentUserPhoneNumber() {
    setState(() {
      _currentUserPhoneNumber = _phoneController.text;
    });
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _phoneController.addListener(_updateCurrentUserPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text('Login'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).buttonColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _isCodeSent
                  ? Container(
                      padding: EdgeInsets.all(32),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Column(
                                children: <Widget>[
                                  Title(
                                    color: Theme.of(context).buttonColor,
                                    child: Text(
                                      "请输入验证码",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text("验证码已发送至" + _currentUserPhoneNumber),
                                  Text("重新发送（" +
                                      _resendCodeTimer.toString() +
                                      "s）"),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: PinInputTextField(
                                      pinLength: 6,
                                      decoration: _pinDecoration,
                                      controller: _pinEditingController,
                                      autoFocus: true,
                                      textInputAction: TextInputAction.done,
                                      onSubmit: (pin) {
                                        if (pin.length == 6) {
                                          //_onFormSubmitted();
                                          loginUser(
                                              _currentUserPhoneNumber, context);
                                        } else {
                                          showToast("Invalid OTP", Colors.red);
                                        }
                                      },
                                      onChanged: (pin) {
                                        if (pin.length == 6) {
                                          //_onFormSubmitted();
                                          loginUser(
                                              _currentUserPhoneNumber, context);
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: RaisedButton(
                                          color: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.0)),
                                          child: Text(
                                            "ENTER OTP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            if (_pinEditingController
                                                    .text.length ==
                                                6) {
                                              loginUser(_currentUserPhoneNumber,
                                                  context);
                                            } else {
                                              showToast(
                                                  "Invalid OTP", Colors.red);
                                            }
                                          },
                                          padding: EdgeInsets.all(16.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(33.5),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Title(
                                color: Theme.of(context).buttonColor,
                                child: Text("登陆 / 注册",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300])),
                                  hintText: "Mobile Number"),
                              controller: _phoneController,
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              child: FlatButton(
                                child: Text("获取验证码登陆"),
                                textColor:
                                    Theme.of(context).textTheme.button.color,
                                padding: EdgeInsets.all(16),
                                onPressed: () {
                                  final phone = _phoneController.text.trim();
                                  loginUser(phone, context);
                                },
                                color: _phoneController.text.length >= 12
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).buttonColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100.0))),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              width: double.infinity,
                              child: FlatButton(
                                child: Text("使用密码登录"),
                                textColor: Theme.of(context).accentColor,
                                padding: EdgeInsets.all(16),
                                onPressed: () {
                                  final phone = _phoneController.text.trim();
                                  loginUser(phone, context);
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              width: double.infinity,
                              child: Column(
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      "点击按钮表示您同意并遵守随行",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        child: Text("《使用协议》"),
                                        onTap: () async {
                                          if (await canLaunch(
                                              "https://www.google.com")) {
                                            await launch(
                                                "https://www.google.com");
                                          }
                                        },
                                      ),
                                      Text("和"),
                                      InkWell(
                                        child: Text("《隐私协议》"),
                                        onTap: () async {
                                          if (await canLaunch(
                                              "https://www.google.com")) {
                                            await launch(
                                                "https://www.google.com");
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}
