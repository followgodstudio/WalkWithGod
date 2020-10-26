import 'package:flutter/material.dart';

import '../../configurations/theme.dart';

class ShareArticle extends StatelessWidget {
  final String articleId;
  ShareArticle(this.articleId);
  @override
  Widget build(BuildContext context) {
    double _iconSize = 35.0;
    double _buttonPadding = 5.0;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(_buttonPadding),
                      child: FlatButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {},
                        child: CircleAvatar(
                            radius: _iconSize,
                            backgroundColor: Theme.of(context).buttonColor,
                            child: Image.asset(
                              'assets/images/wechat.png',
                              width: _iconSize,
                            )),
                        color: Theme.of(context).buttonColor,
                        shape: CircleBorder(),
                      ),
                    ),
                    Text("微信", style: Theme.of(context).textTheme.captionGrey)
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(_buttonPadding),
                      child: FlatButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {},
                        child: CircleAvatar(
                            radius: _iconSize,
                            backgroundColor: Theme.of(context).buttonColor,
                            child: Image.asset(
                              'assets/images/friends_circle.png',
                              width: _iconSize,
                            )),
                        color: Theme.of(context).buttonColor,
                        shape: CircleBorder(),
                      ),
                    ),
                    Text("朋友圈", style: Theme.of(context).textTheme.captionGrey)
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(_buttonPadding),
                      child: FlatButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {},
                        child: CircleAvatar(
                            radius: _iconSize,
                            backgroundColor: Theme.of(context).buttonColor,
                            child: Image.asset(
                              'assets/images/facebook.png',
                              width: _iconSize,
                            )),
                        color: Theme.of(context).buttonColor,
                        shape: CircleBorder(),
                      ),
                    ),
                    Text("Facebook",
                        style: Theme.of(context).textTheme.captionGrey)
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(_buttonPadding),
                      child: FlatButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {},
                        child: CircleAvatar(
                            radius: _iconSize,
                            backgroundColor: Theme.of(context).buttonColor,
                            child: Image.asset(
                              'assets/images/email.png',
                              width: _iconSize,
                            )),
                        color: Theme.of(context).buttonColor,
                        shape: CircleBorder(),
                      ),
                    ),
                    Text("电子邮件", style: Theme.of(context).textTheme.captionGrey)
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("取消",
                      style: Theme.of(context).textTheme.captionSmall),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Theme.of(context).buttonColor),
          ),
        ],
      ),
    );
  }
}
