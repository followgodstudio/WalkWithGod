import 'package:flutter/material.dart';
import 'package:walk_with_god/model/PostRead.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/PostReadPreviewItem.dart';

class PostReadPreviews extends StatefulWidget {
  PostReadPreviews({Key key, this.postReads}) : super(key: key);

  final List<PostRead> postReads;

  @override
  _PostReadPreviewsState createState() => _PostReadPreviewsState();
}

class _PostReadPreviewsState extends State<PostReadPreviews> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 300,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: widget.postReads.map((PostRead e) {
          return PostReadPreviewItem(postRead: e);
        }).toList(),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
