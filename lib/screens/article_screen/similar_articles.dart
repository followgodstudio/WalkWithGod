import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/articles_provider.dart';
import '../../widgets/article_card_small.dart';

class SimilarArticles extends StatelessWidget {
  final String articleId;
  SimilarArticles(this.articleId);
  @override
  Widget build(BuildContext context) {
    //TODO: ArticleProvider should be provided in parent, avoid loadedArticle
    final loadedArticle = Provider.of<ArticlesProvider>(
      context,
      listen: false,
    ).findById(articleId);
    return FutureBuilder(
        future: loadedArticle.findSimilarArticles(),
        builder: (ctx, asyncSnapshot) {
          if (asyncSnapshot.error != null)
            return Center(child: Text('An error occurred!'));
          if (asyncSnapshot.connectionState == ConnectionState.waiting ||
              loadedArticle.similarArticles.length == 0) return SizedBox();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(height: 5),
                Text("猜你喜欢", style: Theme.of(context).textTheme.captionMedium1),
                Container(
                  height: 200,
                  child: ListView(children: [
                    ...loadedArticle.similarArticles
                        .map((e) => ArticleCard(e, 4 / 5))
                        .toList(),
                  ], scrollDirection: Axis.horizontal),
                ),
              ],
            ),
          );
        });
  }
}
