import 'package:flutter/material.dart';
import 'package:walk_with_god/model/PostSaved.dart';

import 'PostSavedPreviews.dart';
import 'TotalSaved.dart';

class SavedPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("我的收藏"),
          ),
          TotalSaved(),
          PostSavedPreviews(postsSaved: PostSavedLists),
        ],
      ),
    );
  }
}
