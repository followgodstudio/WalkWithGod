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
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("我的收藏"),
              ),
              FlatButton(
                  textColor: Color.fromARGB(255, 7, 59, 76),
                  onPressed: null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                        height: 30,
                        width: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Color.fromARGB(255, 240, 240, 240),
                        ),
                        child: Center(
                          child: Text(
                            "查看全部",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        )),
                  )),
            ],
          ),
          TotalSaved(),
          PostSavedPreviews(postsSaved: PostSavedLists),
        ],
      ),
    );
  }
}
