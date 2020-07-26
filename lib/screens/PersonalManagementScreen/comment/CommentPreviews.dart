import 'package:flutter/material.dart';
import 'package:walk_with_god/model/CommentPreview.dart';

import 'CommentPreviewItem.dart';

class CommentPreviews extends StatefulWidget {
  CommentPreviews({this.comments});

  final List<CommentPreview> comments;

  @override
  _CommentPreviewsState createState() => _CommentPreviewsState();
}

class _CommentPreviewsState extends State<CommentPreviews> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: widget.comments.map((CommentPreview e) {
          return CommentPreviewItem(comment: e);
        }).toList(),
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
