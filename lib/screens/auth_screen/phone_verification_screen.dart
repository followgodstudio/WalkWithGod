import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../configurations/theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/navbar.dart';

class PhoneVerificationScreen extends StatefulWidget {
  static const routeName = '/phone_verification';

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  Timer resendTimer;
  int restTime;
  String smsCode;

  void startTimer() {
    setState(() {
      restTime = 60;
    });
    const oneSec = const Duration(seconds: 1);
    resendTimer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (restTime < 1) {
            timer.cancel();
          } else {
            restTime = restTime - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    resendTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String phoneNumber =
        ModalRoute.of(context).settings.arguments as String;
    final _auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: NavBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: Column(children: <Widget>[
              Center(
                child: Text(
                  "请输入验证码",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("验证码已发送至: ",
                      style: Theme.of(context).textTheme.bodyText1),
                  Text(phoneNumber,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: 40),
              PinCodeTextField(
                autoFocus: true,
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                enablePinAutofill: true,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    activeColor: MyColors.silver,
                    activeFillColor: MyColors.silver,
                    selectedColor: MyColors.silver,
                    selectedFillColor: MyColors.silver,
                    inactiveColor: MyColors.silver,
                    inactiveFillColor: MyColors.silver,
                    disabledColor: MyColors.silver,
                    borderWidth: 0),
                cursorColor: Colors.white,
                animationDuration: Duration(milliseconds: 300),
                textStyle: TextStyle(fontSize: 20, height: 1.6),
                backgroundColor: Theme.of(context).canvasColor,
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  setState(() {
                    smsCode = v;
                  });
                },
                onCompleted: (v) {
                  exceptionHandling(context, () async {
                    await _auth.verifyPhoneCode(context, smsCode);
                  });
                },
              ),
              SizedBox(height: 20),
              if (restTime > 0)
                Text("重新发送（" + restTime.toString() + "s）",
                    style: Theme.of(context)
                        .textTheme
                        .captionMedium1
                        .copyWith(color: MyColors.lightGrey)),
              if (restTime == 0)
                FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await exceptionHandling(context, () async {
                        await _auth.signInWithPhone(phoneNumber, context, true);
                      });
                      startTimer();
                    },
                    child: Text("重新发送",
                        style: Theme.of(context)
                            .textTheme
                            .captionMedium1
                            .copyWith(color: MyColors.deepBlue))),
            ]),
          ),
        ),
      ),
    );
  }
}
