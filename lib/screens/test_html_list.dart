import 'package:flutter/material.dart';

import '../widgets/navbar.dart';
import 'test_html_screen.dart';

// ignore: must_be_immutable
class TestHtmlList extends StatelessWidget {
  TestHtmlList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(title: "Test Html", hasBackButton: false),
        body: SingleChildScrollView(
            child: Column(children: [
          FlatButton(
            child: Text("1", style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pushNamed(
                TestHtmlScreen.routeName,
                arguments: "1",
              );
            },
          )
        ])));
  }
}
