import 'package:flutter/material.dart';

import '../configurations/constants.dart';
import '../configurations/theme.dart';
import 'my_text_button.dart';

class PopUpComment extends StatefulWidget {
  final String articleId;
  final Function(String) onPressFunc;
  final String replyTo;
  final bool isReply;

  PopUpComment({
    @required this.articleId,
    @required this.onPressFunc,
    @required this.isReply,
    this.replyTo,
    Key key,
  }) : super(key: key);

  @override
  _PopUpCommentState createState() => _PopUpCommentState();
}

class _PopUpCommentState extends State<PopUpComment> {
  final _commentController = TextEditingController();
  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    String commentName = widget.isReply ? "回复" : "想法";
    String buttonText = widget.isReply ? "回复" : "发布";
    String title =
        widget.replyTo == null ? "添加$commentName" : "@" + widget.replyTo;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.captionMedium1),
            TextField(
              onChanged: (value) {
                setState(() {
                  isEmpty = value == "";
                });
              },
              style: Theme.of(context).textTheme.bodyText1,
              autofocus: true,
              maxLines: 3,
              controller: _commentController,
              decoration: InputDecoration.collapsed(
                hintText: "请写下您的$commentName",
                hintStyle: TextStyle(fontSize: 15.0),
              ),
            ),
            SizedBox(height: 10.0),
            Divider(),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MyTextButton(
                  text: "取消",
                  hasBorder: false,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                MyTextButton(
                    width: 60,
                    text: buttonText,
                    isSmall: false,
                    style: isEmpty
                        ? TextButtonStyle.disabled
                        : TextButtonStyle.active,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onPressFunc(_commentController.text);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
