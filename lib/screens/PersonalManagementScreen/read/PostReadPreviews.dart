import 'package:flutter/material.dart';
import 'package:walk_with_god/model/PostRead.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/read/PostReadPreviewItem.dart';
import 'package:walk_with_god/widgets/slide_dots.dart';

class PostReadPreviews extends StatefulWidget {
  PostReadPreviews({Key key, this.postReads}) : super(key: key);

  final List<PostRead> postReads;

  final dotStates = [false, false, false, false, false, false];

  @override
  _PostReadPreviewsState createState() => _PostReadPreviewsState();
}

class _PostReadPreviewsState extends State<PostReadPreviews> {
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
                return PostReadPreviewItem(
                  postRead: widget.postReads[index],
                  index: index,
                  callback: setDotState,
                );
              },
              itemCount: widget.postReads.length,
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
