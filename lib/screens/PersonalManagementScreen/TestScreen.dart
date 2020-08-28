import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './TestMessages.dart';
import '../../model/Constants.dart';
import '../../providers/ArticleProvider/ArticlesProvider.dart';
import '../../providers/ArticleProvider/ArticleProvider.dart';
import '../../providers/AuthProvider.dart';

class TestScreen extends StatelessWidget {
  static const routeName = '/test';

  @override
  Widget build(BuildContext context) {
    String userId =
        Provider.of<AuthProvider>(context, listen: false).currentUser;
    List<String> aids = ["G45Cl5lT5txWANROo7XY", "MeaMCcvB8mImA3nSravA"];
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
              print(data.articles.length);
              if (data.articles.length > 0) {
                List<Widget> list = [];
                for (var i = 0; i < data.articles.length; i++) {
                  list.add(ChangeNotifierProvider.value(
                    value: data.articles[i],
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
              Text(data.article['title']),
              Text(data.article['author']),
              Text((data.article[F_CREATE_DATE] as Timestamp)
                  .toDate()
                  .toIso8601String())
            ]));
  }
}
