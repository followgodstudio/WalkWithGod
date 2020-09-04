import 'package:flutter/material.dart';

import '../../configurations/theme.dart';
import 'messages/messages_list_screen.dart';
import 'friend/friendship.dart';
import 'head/headLine.dart';
import 'posts/saved_posts.dart';
import 'read/reading.dart';

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
          centerTitle: true,
          title: Text('我的', style: Theme.of(context).textTheme.headline2),
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
                  // HeadLine(),
                  // Friendship(),
                  // Reading(),
                  // SavedPosts(),
                  Messages(),
                ],
              ),
            ),
          ]),
        ));
  }
}

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed(MessagesListScreen.routeName);
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "我的消息",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    "共48条消息",
                    style: Theme.of(context).textTheme.captionMain,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 20.0, color: Color.fromARGB(255, 128, 128, 128)),
          ],
        ),
      ),
    );
  }
}
