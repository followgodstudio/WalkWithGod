import 'package:flutter/material.dart';

import '../configurations/theme.dart';

class PopUpComment extends StatefulWidget {
  final String articleId;
  final Function(String) onPressFunc;
  PopUpComment({
    @required this.articleId,
    @required this.onPressFunc,
  });

  @override
  _PopUpCommentState createState() => _PopUpCommentState();
}

class _PopUpCommentState extends State<PopUpComment> {
  String _text = "";
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    '取消',
                    style: Theme.of(context).textTheme.buttonLarge1,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  '写留言',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Color(0xFFefefef),
                  ),
                  child: FlatButton(
                    child: Text(
                      '发布',
                      style: Theme.of(context).textTheme.buttonLarge1,
                    ),
                    onPressed: () {
                      if (_text != "") {
                        widget.onPressFunc(_text);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
            Divider(
              color: Color.fromARGB(255, 128, 128, 128),
            ),
            Expanded(
              child: TextField(
                autofocus: true,
                onChanged: (newText) {
                  _text = newText;
                },
                maxLines: 11,
                decoration: InputDecoration.collapsed(hintText: '请写下您的留言'),
              ),
            ),
            Divider(
              color: Color.fromARGB(255, 128, 128, 128),
            ),
          ],
        ),
      ),
    );
  }
}
