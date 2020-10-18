import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/article_provider.dart';
import '../../widgets/article_card.dart';

class SimilarArticles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleProvider>(builder: (context, value, child) {
      if (value.similarArticles.length == 0) return SizedBox();
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
                ...value.similarArticles
                    .map((element) =>
                        ArticleCard(article: element, verticalPadding: 12.5))
                    .toList(),
              ], scrollDirection: Axis.horizontal),
            ),
          ],
        ),
      );
    });
  }
}
