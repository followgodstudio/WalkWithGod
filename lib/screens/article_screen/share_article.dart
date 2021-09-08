import 'package:flutter/material.dart';

import '../../configurations/theme.dart';
import '../../../widgets/my_text_button.dart';

class ShareArticle extends StatelessWidget {
  final String articleId;
  ShareArticle(this.articleId);
  @override
  Widget build(BuildContext context) {
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
                ShareButton('assets/images/wechat.png', "微信"),
                ShareButton('assets/images/friends_circle.png', "朋友圈"),
                ShareButton('assets/images/facebook.png', "Facebook"),
                ShareButton('assets/images/email.png', "电子邮件"),
              ],
            ),
          ),
          MyTextButton(
            width: double.infinity,
            text: "取消",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  final String imageAsset;
  final String imageText;
  ShareButton(this.imageAsset, this.imageText);
  @override
  Widget build(BuildContext context) {
    double _iconSize = 35.0;
    double _buttonPadding = 10.0;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(_buttonPadding),
          child: ElevatedButton(
            onPressed: () {},
            child: CircleAvatar(
                radius: _iconSize,
                backgroundColor: Theme.of(context).buttonColor,
                child: Image.asset(
                  this.imageAsset,
                  width: _iconSize,
                )),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: CircleBorder(),
              primary: Theme.of(context).buttonColor,
              shadowColor: Colors.transparent,
            ),
          ),
        ),
        Text(this.imageText, style: Theme.of(context).textTheme.captionGrey)
      ],
    );
  }
}
