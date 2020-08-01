import 'package:flutter/material.dart';
import 'package:walk_with_god/model/PostRead.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/read/PostReadPreviews.dart';

class Reading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text("最近阅读"),
          ),
          PostReadPreviews(postReads: postReadList),
        ],
      ),
    );
  }
}
