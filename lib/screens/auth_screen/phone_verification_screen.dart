import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/utils/utils.dart';

import '../../configurations/constants.dart';
import '../../configurations/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/navbar.dart';

class PhoneVerificationScreen extends StatefulWidget {
  static const routeName = '/phone_verification';

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final Map parameter = ModalRoute.of(context).settings.arguments as Map;
    final String phoneNumber = parameter["phoneNumber"];
    final String verificationId = parameter["verificationId"];
    final textEditingController = TextEditingController();
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
              SizedBox(height: 30),
              PinCodeTextField(
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
                controller: textEditingController,
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  final _auth =
                      Provider.of<AuthProvider>(context, listen: false);
                  exceptionHandling(context, () async {
                    await _auth.verifyPhoneCode(context, verificationId,
                        textEditingController.text.trim());
                  });
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
