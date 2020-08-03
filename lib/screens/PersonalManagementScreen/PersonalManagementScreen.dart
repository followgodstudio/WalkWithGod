import 'package:flutter/material.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/friend/Friendship.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/head/HeadLine.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/posts/SavedPosts.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/read/Reading.dart';

import 'comment/Comments.dart';

class PersonalManagementScreen extends StatefulWidget {
  static const routeName = '/personal_management';
  @override
  _PersonalManagementScreen createState() => _PersonalManagementScreen();
}

class _PersonalManagementScreen extends State<PersonalManagementScreen> {
  String _currentUserPhoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Text('Personal Management'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Theme.of(context).buttonColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: <Widget>[
                  HeadLine(),
                  Friendship(),
                  Reading(),
                  SavedPosts(),
                  Comments(),
                ],
              ),
            ),
          ]),
        ));
  }
}
