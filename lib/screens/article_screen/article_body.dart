import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/screens/article_screen/article_body_html.dart';

import '../../configurations/constants.dart';
import '../../providers/article/article_provider.dart';
import '../../utils/my_logger.dart';
import '../../widgets/aricle_paragraph.dart';
import '../../widgets/article_card.dart';
import '../../widgets/my_progress_indicator.dart';
import '../../widgets/my_text_button.dart';
import 'article_body_html2.dart';

class ArticleBody extends StatefulWidget {
  @override
  _ArticleBodyState createState() => _ArticleBodyState();
}

class _ArticleBodyState extends State<ArticleBody> {
  int index = 0;
  List<String> styles = ["default", "flutter_html", "easy_web_view"];
  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").v("ArticleBody-build");
    return Consumer<ArticleProvider>(builder: (context, article, child) {
      if (article.id == null || article.content.length == 0)
        return MyProgressIndicator();
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ArticleCard(article: article, isSmall: false),
        SizedBox(height: 10.0),
        if (article.contentHtml != null)
          Center(
            child: MyTextButton(
              text: "On " + styles[index] + " screen, switch?",
              style: TextButtonStyle.active,
              width: 300,
              onPressed: () {
                setState(() {
                  index = (index + 1) % 3;
                });
              },
            ),
          ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: (index == 1)
                ? ArticleBodyHtml(article.contentHtml)
                : (index == 2)
                    ? ArticleBodyHtml2(article.contentHtml)
                    : Column(children: [
                        ...article.content.map((e) => ArticleParagraph(e))
                      ]))
      ]);
    });
  }
}
