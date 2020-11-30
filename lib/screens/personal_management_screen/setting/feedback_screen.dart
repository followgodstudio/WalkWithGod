import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:walk_with_god/utils/utils.dart';

import '../../../configurations/constants.dart';
import '../../../widgets/my_text_button.dart';
import '../../../widgets/navbar.dart';

class FeedbackScreen extends StatefulWidget {
  static const routeName = '/feedback';

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  bool isEmpty = true;
  final _commentController = TextEditingController();

  Future<void> send(text, context) async {
    final Email email = Email(
      body: text,
      subject: "用户建议",
      recipients: ["followgod.studio@gmail.com"],
    );
    await exceptionHandling(context, () async {
      await FlutterEmailSender.send(email);
      showPopUpDialog(context, true, "感谢您的建议", afterDismiss: () {
        Navigator.of(context).pop(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: NavBar(title: "用户建议"),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      isEmpty = value == "";
                    });
                  },
                  maxLines: null,
                  style: Theme.of(context).textTheme.bodyText1,
                  autofocus: true,
                  controller: _commentController,
                  decoration: InputDecoration.collapsed(
                    hintText: "请写下您的建议",
                    hintStyle: TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              MyTextButton(
                width: double.infinity,
                isSmall: false,
                style:
                    isEmpty ? TextButtonStyle.disabled : TextButtonStyle.active,
                text: "提交",
                onPressed: () => send(_commentController.text, context),
              )
            ],
          ),
        )));
  }
}
