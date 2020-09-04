import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

import '../configurations/theme.dart';

class PopUpComment extends StatelessWidget {
  final Function(String) onPressFunc;
  final _commentController = TextEditingController();

  PopUpComment({
    @required this.onPressFunc,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Container(
                decoration: DottedDecoration(
                  shape: Shape.line,
                  linePosition: LinePosition.bottom,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20.0)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                maxLines: 11,
                controller: _commentController,
                decoration: InputDecoration.collapsed(hintText: '请写下您的留言'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Color(0xFFefefef),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child:
                          Image(image: AssetImage('assets/images/image0.jpg'))),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '只要互联网还在, 我就不会停止',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          '海外校园  |  范学德',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
