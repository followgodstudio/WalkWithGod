import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../configurations/constants.dart';
import '../../../configurations/theme.dart';
import '../../../providers/user/message_provider.dart';
import '../../../widgets/profile_picture.dart';
import '../../article_screen/article_screen.dart';

class MessageItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
        builder: (context, data, child) => FlatButton(
              onPressed: () {
                data.markMessageAsRead(true);
                Navigator.of(context).pushNamed(
                  ArticleScreen.routeName,
                  arguments: {
                    "articleId": data.articleId,
                    "commentId": data.commentId
                  },
                );
              },
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      ProfilePicture(20.0, data.senderImage, data.senderUid),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text(data.senderName,
                              style: data.isRead
                                  ? Theme.of(context).textTheme.buttonMediumGray
                                  : Theme.of(context).textTheme.buttonMedium1)),
                      SizedBox(width: 10),
                      Text(
                        DateFormat('yyyy年M月d日 HH:mm a').format(data.createDate),
                        style: data.isRead
                            ? Theme.of(context).textTheme.captionSmall3
                            : Theme.of(context).textTheme.captionSmallBlack,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 45, right: 8, top: 4, bottom: 8),
                      child: Icon(
                          data.type == eMessageTypeReply
                              ? Icons.message
                              : Icons.favorite_border,
                          size: 15,
                          color: data.isRead
                              ? Color.fromARGB(255, 194, 194, 194)
                              : Colors.black87),
                    ),
                    Text(
                      data.senderName +
                          (data.type == eMessageTypeReply ? "评论" : "") +
                          (data.type == eMessageTypeLike ? "点赞" : "") +
                          "了你的留言。",
                      style: data.isRead
                          ? Theme.of(context).textTheme.captionMedium3
                          : Theme.of(context).textTheme.captionMedium4,
                    ),
                  ],
                ),
                Divider(),
              ]),
            ));
  }
}
