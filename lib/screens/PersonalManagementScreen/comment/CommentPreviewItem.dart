import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walk_with_god/model/CommentPreview.dart';
import 'package:walk_with_god/model/PostSaved.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/comment/SmallPostPreviewItem.dart';

class CommentPreviewItem extends StatelessWidget {
  CommentPreviewItem({this.comment});

  final CommentPreview comment;

  PostSaved getPostCommentedTo() {
    return PostSavedLists[0];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 20, right: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(comment.user.avatar_url),
            backgroundColor: Colors.brown.shade800,
          ),
          Column(
            //title and time
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  DateFormat('yyyy-MM-dd H:m:s').format(comment.updatedAt),
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
              Container(
                width: 300,
                child: Text(
                  comment.content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
              SmallPostPreviewItem(post: this.getPostCommentedTo()),
            ],
          ),
        ],
      ),
    );
  }
}
