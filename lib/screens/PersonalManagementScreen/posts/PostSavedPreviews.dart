import 'package:flutter/material.dart';
import 'package:walk_with_god/model/PostSaved.dart';
<<<<<<< HEAD
import 'package:walk_with_god/widgets/slide_dots.dart';
=======
>>>>>>> WIP saved posts

import 'PostSavedPreviewItem.dart';

class PostSavedPreviews extends StatefulWidget {
  PostSavedPreviews({this.postsSaved});

  final List<PostSaved> postsSaved;

<<<<<<< HEAD
  final dotStates = [false, false, false, false, false, false];

=======
>>>>>>> WIP saved posts
  @override
  _PostSavedPreviewsState createState() => _PostSavedPreviewsState();
}

class _PostSavedPreviewsState extends State<PostSavedPreviews> {
<<<<<<< HEAD
  void setDotState(int index) {
    setState(() {
      for (int i = 0; i < 6; i++) {
        if (widget.dotStates[i] == true) {
          widget.dotStates[i] = false;
        }
      }
      if (index >= 0 && index < 6) {
        widget.dotStates[index] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      child: Column(
        children: <Widget>[
          Container(
            height: 300,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return PostSavedPreviewItem(
                  postSaved: widget.postsSaved[index],
                  index: index,
                  callback: setDotState,
                );
              },
              itemCount: widget.postsSaved.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SlideDots(widget.dotStates[0]),
              SlideDots(widget.dotStates[1]),
              SlideDots(widget.dotStates[2]),
              SlideDots(widget.dotStates[3]),
              SlideDots(widget.dotStates[4]),
              SlideDots(widget.dotStates[5]),
            ],
          )
        ],
=======
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 300,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: widget.postsSaved.map((PostSaved e) {
          return PostSavedPreviewItem(postSaved: e);
        }).toList(),
        scrollDirection: Axis.horizontal,
>>>>>>> WIP saved posts
      ),
    );
  }
}
