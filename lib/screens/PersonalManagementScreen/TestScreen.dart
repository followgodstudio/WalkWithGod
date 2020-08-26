import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './TestMessages.dart';
import '../../model/Constants.dart';
import '../../providers/UserProvider/UserProvider.dart';
import '../../providers/UserProvider/MessageProvider.dart';
import '../../providers/AuthProvider.dart';

class TestScreen extends StatelessWidget {
  static const routeName = '/test';

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<Auth>(context, listen: false).currentUser;
    // Test
    // userId = "2xxmzDxLnUP97GBX2flyi2JfhGF2";
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(userId),
        ),
        ChangeNotifierProvider(
          create: (context) => MessageProvider(userId),
        ),
      ],
      child: Scaffold(
          body: SingleChildScrollView(
              child: Column(children: <Widget>[
        Text(userId != null ? userId : ""),
        FlatButton(
          child:
              Row(children: <Widget>[Icon(Icons.exit_to_app), Text('Logout')]),
          onPressed: () {
            Provider.of<Auth>(context, listen: false).logout();
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Builder(
          builder: (BuildContext context) {
            BuildContext rootContext = context;
            return FutureBuilder(
                future: Provider.of<UserProvider>(rootContext, listen: false)
                    .load(),
                builder: (context, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Consumer<UserProvider>(
                        builder: (context, userData, child) =>
                            Column(children: <Widget>[
                              child,
                              TestMessages(userId),
                              StreamBuilder(
                                  stream: userData.loadSnap(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      DocumentSnapshot doc = snapshot.data;
                                      return Text((doc.data != null &&
                                              doc.data['name'] != null)
                                          ? doc.data['name']
                                          : "");
                                    } else {
                                      return Text("Loading");
                                    }
                                  }),
                              Text("User Name:"),
                              Text(userData.profile[FIELD_USER_NAME] != null
                                  ? userData.profile[FIELD_USER_NAME]
                                  : ""),
                              Text("User image url:"),
                              Text(userData.profile[FIELD_USER_IMAGEURL] != null
                                  ? userData.profile[FIELD_USER_IMAGEURL]
                                  : ""),
                              Text("Follower: "),
                              if (userData.followers != null)
                                ...userData.followers
                                    .map(
                                      (follower) => Text(follower),
                                    )
                                    .toList(),
                              Text("Following: "),
                              if (userData.followings != null)
                                ...userData.followings
                                    .map(
                                      (following) => Text(following),
                                    )
                                    .toList(),
                              Text("Messages: "),
                              if (userData.messages != null)
                                ...userData.messages
                                    .map(
                                      (message) => Text(message),
                                    )
                                    .toList(),
                              Text("Saved Articles: "),
                              if (userData.savedArticles != null)
                                ...userData.savedArticles
                                    .map(
                                      (savedArticle) => Text(savedArticle),
                                    )
                                    .toList(),
                            ]),
                        child: RaisedButton(
                            child: Text("Save"),
                            onPressed: () async {
                              await Provider.of<UserProvider>(context,
                                      listen: false)
                                  .save();
                            }));
                  }
                });
          },
        )
      ]))),
    );
  }
}
