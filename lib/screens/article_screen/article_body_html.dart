import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../../configurations/theme.dart';
import '../../utils/my_logger.dart';

class ArticleBodyHtml extends StatelessWidget {
  final String htmlData;
  ArticleBodyHtml(this.htmlData);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      style: {
        "h1": Style(
          color: MyColors.black,
          fontSize: FontSize(21.5),
          fontFamily: 'Song',
          letterSpacing: 2,
        ),
        "p": Style(
          color: MyColors.black,
          fontSize: FontSize(16.0),
          fontFamily: 'Hei',
          fontWeight: FontWeight.w300,
          letterSpacing: 1.4,
        ),
      },
      onLinkTap: (url) {
        MyLogger("Widget").i("ArticleBodyHtml-build-Opening $url");
      },
      onImageTap: (src) {
        MyLogger("Widget").i("ArticleBodyHtml-build-Image $src");
      },
      onImageError: (exception, stackTrace) {
        MyLogger("Widget").e("ArticleBodyHtml-build-Image $exception");
      },
    );
  }
}
