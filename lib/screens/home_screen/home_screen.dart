import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import '../../providers/article/articles_provider.dart';

import '../../configurations/theme.dart';
import 'article/article_list.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final FirebaseUser user;
  final Firestore firestore;

  HomeScreen({this.user, this.firestore});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // if (_isInit) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   Provider.of<ArticlesProvider>(context)
    //       .fetchArticlesByDate(new DateTime.utc(1989, 11, 9))
    //       .then((_) {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    // }
    // _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshArticles(BuildContext ctx) async {
    await Provider.of<ArticlesProvider>(context, listen: false)
        .fetchArticlesByDate(new DateTime.utc(1989, 11, 9));
  }

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMM dd, yyyy');
    String formattedDate = formatter.format(now);

    return Scaffold(
        body: SafeArea(
            child: FutureBuilder(
                future: Provider.of<ArticlesProvider>(context, listen: false)
                    .fetchArticlesByDate(new DateTime.utc(1989, 11, 9)),
                builder: (ctx, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (asyncSnapshot.error != null) {
                      return Center(
                        child: Text('An error occurred!'),
                      );
                    } else {
                      return RefreshIndicator(
                          onRefresh: () => _refreshArticles(context),
                          child: Consumer<ArticlesProvider>(
                              builder: (context, data, child) {
                            return CustomScrollView(slivers: <Widget>[
                              SliverAppBar(
                                toolbarHeight: 48.0,
                                shadowColor: Theme.of(context).canvasColor,
                                backgroundColor: Theme.of(context).canvasColor,
                                pinned: true,
                                automaticallyImplyLeading: false,
                                flexibleSpace: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          FlatButton(
                                              onPressed: () {},
                                              child: Text(
                                                "今日",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .captionMedium2,
                                              )),
                                        ],
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {},
                                      child: Text(
                                        formattedDate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .captionMain,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  FlatButton(
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).canvasColor,
                                      backgroundImage:
                                          AssetImage("assets/images/logo.png"),
                                    ),
                                    onPressed: () {},
                                  )
                                ],
                              ),
                              ArticleList(),
                            ]);
                          }));
                    }
                  }
                })));
  }
}
