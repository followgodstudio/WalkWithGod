import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/constants.dart';
import '../../providers/article/article_provider.dart';
import '../../utils/my_logger.dart';
import '../../widgets/aricle_paragraph.dart';
import '../../widgets/article_card.dart';
import '../../widgets/my_progress_indicator.dart';
import '../../widgets/my_text_button.dart';
import 'article_body_html.dart';

class ArticleBody extends StatefulWidget {
  @override
  _ArticleBodyState createState() => _ArticleBodyState();
}

class _ArticleBodyState extends State<ArticleBody> {
  bool showHtml = false;
  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").v("ArticleBody-build");
    return Consumer<ArticleProvider>(builder: (context, article, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (article.id == null) MyProgressIndicator(),
        if (article.id != null)
          ArticleCard(article: article, style: ArticleCardStyle.title),
        SizedBox(height: 10.0),
        // if (article.contentHtml != null)
        //   Center(
        //     child: MyTextButton(
        //       text: showHtml
        //           ? "Switch to default screen"
        //           : "Switch to html screen",
        //       style: TextButtonStyle.active,
        //       width: 250,
        //       onPressed: () {
        //         setState(() {
        //           showHtml = !showHtml;
        //         });
        //       },
        //     ),
        //   ),
        if (article.content.length > 0)
          Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: (showHtml)
                  ? ArticleBodyHtml(article.contentHtml)
                  : Column(children: [
                      ...article.content.map((e) => ArticleParagraph(e))
                    ]))
      ]);
    });
  }
}
