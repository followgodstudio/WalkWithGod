import 'package:flutter/material.dart';
import 'package:walk_with_god/model/PostSaved.dart';

import 'PostSavedPreviewItem.dart';

class PostSavedPreviews extends StatefulWidget {
  PostSavedPreviews({this.postsSaved});

  final List<PostSaved> postsSaved;

  @override
  _PostSavedPreviewsState createState() => _PostSavedPreviewsState();
}

class _PostSavedPreviewsState extends State<PostSavedPreviews> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: widget.postsSaved.map((PostSaved e) {
          return PostSavedPreviewItem(postSaved: e);
        }).toList(),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
