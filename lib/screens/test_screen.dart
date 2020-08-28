import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/constants.dart';
import '../providers/article/article_provider.dart';
import '../providers/article/articles_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user/messages_provider.dart';

// This screen is used to test the providers

class TestScreen extends StatelessWidget {
  static const routeName = '/test';

  @override
  Widget build(BuildContext context) {
    String userId =
        Provider.of<AuthProvider>(context, listen: false).currentUser;
    List<String> aids = ["G45Cl5lT5txWANROo7XY"];
    return Scaffold(
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
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          TestMessages(userId),
          FutureBuilder(
            future: Provider.of<ArticlesProvider>(context, listen: false)
                .fetchList(aids),
            builder: (ctx, _) =>
                Consumer<ArticlesProvider>(builder: (context, data, child) {
              print(data.items.length);
              if (data.items.length > 0) {
                List<Widget> list = [];
                for (var i = 0; i < data.items.length; i++) {
                  list.add(ChangeNotifierProvider.value(
                    value: data.items[i],
                    child: TestArticle(),
                  ));
                }
                return Column(children: list);
              } else {
                return Text("None...");
              }
            }),
          ),
        ])));
  }
}

class TestArticle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(
        builder: (context, data, child) => Column(children: [
              Text("Article:"),
              Text(data.title),
              Text(data.author),
            ]));
  }
}

class TestMessages extends StatelessWidget {
  TestMessages(String uid);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Messages:"),
        RaisedButton(
            child: Text("Add message"),
            onPressed: () {
              Provider.of<MessagesProvider>(context, listen: false).add(
                  eUserMessageTypecomment,
                  'test_uid',
                  'test_aid',
                  "Hello from dart!");
            }),
        Consumer<MessagesProvider>(
          builder: (context, data, child) => StreamBuilder(
              stream: data.getStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  docs.sort((d1, d2) {
                    return d1[fCreateDate].compareTo(d2[fCreateDate]);
                  });
                  return Column(
                      children: docs
                          .map((doc) => Row(
                                children: [
                                  Text(DateFormat("yyyy-MM-dd hh:mm:ss").format(
                                      (doc.data[fCreateDate] as Timestamp)
                                          .toDate())),
                                  Text("   "),
                                  Text(doc.data[fUserMessageBody] != null
                                      ? doc.data[fUserMessageBody]
                                      : ""),
                                ],
                              ))
                          .toList());
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ),
      ],
    );
  }
}
