import 'package:flutter/material.dart';

import '../configurations/theme.dart';
import '../screens/auth_screen/signup_screen.dart';
import 'my_text_button.dart';

class PopupLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double buttonWidth = 150.0;
    double buttonHeight = 45.0;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("请您先登录", style: Theme.of(context).textTheme.buttonLarge),
          SizedBox(height: 10),
          Text("登录后，您可以点赞该文章。"),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyTextButton(
                height: buttonHeight,
                width: buttonWidth,
                text: "取消",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MyTextButton(
                height: buttonHeight,
                width: buttonWidth,
                style: TextButtonStyle.active,
                buttonColor: MyColors.yellow,
                text: "登录",
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(SignupScreen.routeName);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
