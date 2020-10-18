import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configurations/theme.dart';
import '../../../providers/user/saved_articles_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/article_card.dart';
import '../../../widgets/navbar.dart';

// TODO: add saved articles search
class SavedArticlesScreen extends StatelessWidget {
  static const routeName = '/saved_articles';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NavBar(title: "我的收藏"),
        body: SafeArea(
          child: NotificationListener<ScrollNotification>(onNotification:
              (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              exceptionHandling(context, () async {
                await Provider.of<SavedArticlesProvider>(context, listen: false)
                    .fetchMoreSavedArticles();
              });
            }
            return true;
          }, child:
              Consumer<SavedArticlesProvider>(builder: (context, saved, child) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomScrollView(slivers: [
                if (saved.articles.length == 0)
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("暂无收藏",
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.captionMedium3),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (saved.articles.length > 0)
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 4 / 5, crossAxisCount: 2),
                    delegate: SliverChildListDelegate(
                      [
                        ...saved.articles
                            .map((element) => ArticleCard(article: element))
                            .toList()
                      ],
                    ),
                  ),
                if (saved.articles.length > 0)
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Divider(),
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(saved.noMore ? "到底啦" : "加载更多",
                                  style: Theme.of(context)
                                      .textTheme
                                      .captionMedium3)),
                        ),
                      ],
                    ),
                  ),
              ]),
            );
          })),
        ));
  }
}
