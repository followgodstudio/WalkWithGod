import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../providers/article/articles_provider.dart';
import '../../widgets/article_card.dart';

class ArticleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final articlesData = Provider.of<ArticlesProvider>(context, listen: false);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: 12.5),
            child: ArticleCard(
                hasDescription: true,
                article: articlesData.articles[index],
                isSmall: false),
          );
        },
        childCount:
            articlesData.articles == null ? 0 : articlesData.articles.length,
      ),
    );
  }
}
