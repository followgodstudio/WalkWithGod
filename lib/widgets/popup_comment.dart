import 'package:flutter/material.dart';

import '../configurations/theme.dart';

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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.replyTo == null ? "添加留言" : "@" + widget.replyTo,
                  style: TextStyle(fontSize: 15.0),
                )
              ],
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
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text("取消"),
                ),
                Container(
                  width: 62.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      color: isEmpty
                          ? Color.fromARGB(255, 246, 246, 246)
                          : Color.fromARGB(255, 50, 197, 255)),
                  child: FlatButton(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      '发布',
                      style: isEmpty
                          ? Theme.of(context).textTheme.buttonMedium1
                          : Theme.of(context).textTheme.bodyTextWhite,
                    ),
                    onPressed: () {
                      if (!isEmpty) {
                        Navigator.pop(context);
                        widget.onPressFunc(_commentController.text);
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
