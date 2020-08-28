import 'package:flutter/material.dart';

import '../../../model/comment_preview.dart';
import 'comment_previews.dart';
import 'total_comment.dart';

class Comments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("我的留言"),
          ),
          TotalComment(),
          CommentPreviews(comments: commentPreviewList),
        ],
      ),
    );
  }
}
