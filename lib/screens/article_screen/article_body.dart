import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../providers/article/article_provider.dart';
import '../../utils/my_logger.dart';
import '../../widgets/aricle_paragraph.dart';
import '../../widgets/article_card.dart';
import '../../widgets/my_progress_indicator.dart';

class ArticleBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").v("ArticleBody-build");
    return Consumer<ArticleProvider>(builder: (context, article, child) {
      if (article.id == null || article.content.length == 0)
        return MyProgressIndicator();
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ArticleCard(article: article, isSmall: false),
        SizedBox(height: 10.0),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
                children: [...article.content.map((e) => ArticleParagraph(e))]))
      ]);
    });
  }
}
