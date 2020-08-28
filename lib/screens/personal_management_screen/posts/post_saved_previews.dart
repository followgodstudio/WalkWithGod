import 'package:flutter/material.dart';

import '../../../model/post_saved.dart';
import '../../../widgets/slide_dots.dart';
import 'post_saved_preview_item.dart';

class PostSavedPreviews extends StatefulWidget {
  PostSavedPreviews({this.postsSaved});

  final List<PostSaved> postsSaved;

  final dotStates = [false, false, false, false, false, false];

  @override
  _PostSavedPreviewsState createState() => _PostSavedPreviewsState();
}

class _PostSavedPreviewsState extends State<PostSavedPreviews> {
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
      ),
    );
  }
}
