import 'package:flutter/material.dart';

import '../configurations/constants.dart';
import 'my_button.dart';

class PopUpComment extends StatefulWidget {
  final String articleId;
  final Function(String) onPressFunc;
  final String replyTo;

  PopUpComment({
    @required this.articleId,
    @required this.onPressFunc,
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
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.replyTo == null ? "添加留言" : "@" + widget.replyTo,
              style: TextStyle(fontSize: 15.0),
            ),
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
                hintText: "请写下你的留言",
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
                Container(
                  width: 60,
                  child: MyTextButton(
                      text: widget.replyTo == null ? "发布" : "回复",
                      isSmall: false,
                      style: isEmpty
                          ? TextButtonStyle.disabled
                          : TextButtonStyle.active,
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onPressFunc(_commentController.text);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
