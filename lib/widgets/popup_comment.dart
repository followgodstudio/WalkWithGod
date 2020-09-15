import 'package:flutter/material.dart';

import '../configurations/theme.dart';

class PopUpComment extends StatelessWidget {
  final String articleId;
  final Function(String) onPressFunc;
  final _commentController = TextEditingController();

  PopUpComment({
    @required this.articleId,
    @required this.onPressFunc,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      if (_commentController.text != "") {
                        onPressFunc(_commentController.text);
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
                // showCursor: true,
                // readOnly: true,
                //autofocus: true,
                maxLines: 11,
                controller: _commentController,
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
