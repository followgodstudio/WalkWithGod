import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './TestMessages.dart';
import '../../providers/UserProvider/MessageProvider.dart';
import '../../providers/AuthProvider.dart';

class TestScreen extends StatelessWidget {
  static const routeName = '/test';

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).currentUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MessageProvider(userId),
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            title: Text('Test Personal Management'),
            backgroundColor: Color(0),
          ),
          body: SingleChildScrollView(
              child: Column(children: <Widget>[
            Text("User ID:"),
            Text(userId != null ? userId : ""),
            FlatButton(
              child: Row(
                  children: <Widget>[Icon(Icons.exit_to_app), Text('Logout')]),
              onPressed: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            TestMessages(userId),
          ]))),
    );
  }
}
