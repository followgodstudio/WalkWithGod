import 'package:flutter/material.dart';

import 'summary.dart';

class Introduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
            onPressed: null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                "https://photo.sohu.com/88/60/Img214056088.jpg",
                fit: BoxFit.cover,
                height: 60.0,
                width: 60.0,
              ),
            )),
        Text(
          "你好，凯瑟琳",
          style: Theme.of(context).textTheme.headline1,
        ),
      ],
    );
  }
}

class HeadLine extends StatefulWidget {
  HeadLine({Key key}) : super(key: key);

  // The framework calls createState the first time a widget
  // appears at a given location in the tree.
  // If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses the State object
  // instead of creating a new State object.

  @override
  _HeadLineState createState() => _HeadLineState();
}

class _HeadLineState extends State<HeadLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Introduction(),
//          Summary(),
        ],
      ),
    );
  }
}
