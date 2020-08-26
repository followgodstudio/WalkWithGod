import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/ArticleProvider.dart';
import '../../providers/AuthProvider.dart';
import './Article.dart';

class ReadArticlesScreen extends StatelessWidget {
  static const routeName = '/readarticles';

  @override
  Widget build(BuildContext context) {
    String articleId = "G45Cl5lT5txWANROo7XY";
    String userId = Provider.of<Auth>(context, listen: false).currentUser;
    return ChangeNotifierProvider(
      create: (context) => ArticleProvider(articleId),
      child: Scaffold(
          body: SingleChildScrollView(
              child: Column(children: <Widget>[
        // Just for testing
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
                future: Provider.of<ArticleProvider>(rootContext, listen: false)
                    .load(),
                builder: (context, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Consumer<ArticleProvider>(
                        builder: (context, articleData, child) =>
                            Article(articleId, articleData.article));
                  }
                });
          },
        )
      ]))),
    );
  }
}
