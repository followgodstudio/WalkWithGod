import 'package:flutter/material.dart';

import '../../../model/post_saved.dart';
import 'post_saved_previews.dart';
import 'total_saved.dart';

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
