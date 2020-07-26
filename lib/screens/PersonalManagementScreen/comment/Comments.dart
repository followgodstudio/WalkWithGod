import 'package:flutter/material.dart';
import 'package:walk_with_god/model/CommentPreview.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/comment/CommentPreviews.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/comment/TotalComment.dart';

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
