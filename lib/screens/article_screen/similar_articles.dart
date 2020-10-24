import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../configurations/theme.dart';
import '../../providers/article/article_provider.dart';
import '../../widgets/article_card.dart';

class SimilarArticles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(builder: (context, value, child) {
      if (value.similarArticles.length == 0) return SizedBox();
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            SizedBox(height: 10.0),
            Text("相似推荐", style: Theme.of(context).textTheme.captionMedium1),
            Container(
              height: 210,
              child: ListView(children: [
                ...value.similarArticles
                    .map((element) => Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 12.5, bottom: 20),
                          child: ArticleCard(article: element),
                        ))
                    .toList(),
              ], scrollDirection: Axis.horizontal),
            ),
          ],
        ),
      );
    });
  }
}
