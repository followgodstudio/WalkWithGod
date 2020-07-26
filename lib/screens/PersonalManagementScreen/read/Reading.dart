import 'package:flutter/material.dart';
import 'package:walk_with_god/model/PostRead.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/read/PostReadPreviews.dart';
<<<<<<< HEAD
=======
import 'package:walk_with_god/widgets/slide_dots.dart';
>>>>>>> add comments section

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
<<<<<<< HEAD
=======
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SlideDots(true),
              SlideDots(false),
              SlideDots(false),
              SlideDots(false),
              SlideDots(false),
              SlideDots(false),
            ],
          )
>>>>>>> add comments section
        ],
      ),
    );
  }
}
