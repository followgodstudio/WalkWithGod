import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../providers/article/articles_provider.dart';
import '../../providers/article/comments_provider.dart';
import '../../providers/user/profile_provider.dart';
import 'article_body.dart';
import 'bottom_bar.dart';
import 'comments.dart';
import 'top_bar.dart';

class ArticleScreen extends StatelessWidget {
  static const routeName = '/article_screen';
  @override
  Widget build(BuildContext context) {
    final String _articleId =
        ModalRoute.of(context).settings.arguments as String;
    final HideNavbar hiding = HideNavbar();
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                Provider.of<CommentsProvider>(context, listen: false)
                    .fetchMoreL1Comments(
                        Provider.of<ProfileProvider>(context, listen: false)
                            .uid);
              }
              return true;
            },
            child: FutureBuilder(
                future: Provider.of<ArticlesProvider>(context, listen: true)
                    .fetchArticleConentById(_articleId),
                builder: (ctx, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (asyncSnapshot.error != null)
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('An error occurred!'),
                        content: Text('Something went wrong.'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Okay'),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          )
                        ],
                      ),
                    );
                  return CustomScrollView(
                    controller: hiding.controller,
                    slivers: <Widget>[
                      TopBar(_articleId),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ArticleBody(_articleId),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Comments(articleId: _articleId),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: hiding.visible,
        builder: (context, bool value, child) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: value ? 60.0 : 0.0,
          child: value
              ? BottomBar(_articleId)
              : Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                ),
        ),
      ),
    );
  }
}

class HideNavbar {
  final ScrollController controller = ScrollController();
  ValueNotifier<bool> visible = ValueNotifier<bool>(true);

  HideNavbar() {
    visible.value = true;
    controller.addListener(
      () {
        if (controller.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (visible.value) {
            visible.value = false;
          }
        }

        if (controller.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!visible.value) {
            visible.value = true;
          }
        }
      },
    );
  }
}
