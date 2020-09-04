import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/screens/article_screen/comment_detail_screen.dart';

import '../../../configurations/theme.dart';
import '../../../model/constants.dart';
import '../../../providers/user/message_provider.dart';

// TODO: add unread message format
class MessageItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MessageProvider>(
        builder: (context, data, child) => FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CommentDetailScreen.routeName,
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
                      CircleAvatar(
                        backgroundImage: NetworkImage(data.senderImage),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text(data.senderName,
                              style:
                                  Theme.of(context).textTheme.buttonMedium1)),
                      SizedBox(width: 10),
                      Text(
                        DateFormat('yyyy年M月d日 H:m a').format(data.createDate),
                        style: Theme.of(context).textTheme.captionSmall3,
                      ),
                    ],
                  ),
                ),
                if (data.type == eMessageTypeReply)
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 45, right: 8, top: 4, bottom: 8),
                        child: Icon(Icons.message, size: 15),
                      ),
                      Text(data.senderName + "回复了你的留言。",
                          style: Theme.of(context).textTheme.captionMedium4),
                    ],
                  ),
                if (data.type == eMessageTypeLike)
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 45, right: 8, top: 4, bottom: 8),
                        child: Icon(Icons.favorite_border, size: 15),
                      ),
                      Text(
                        data.senderName + "点赞了你的留言。",
                        style: Theme.of(context).textTheme.captionMedium4,
                      ),
                    ],
                  ),
                Divider(
                  color: Color.fromARGB(255, 128, 128, 128),
                ),
              ]),
            ));
  }
}
