import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../../configurations/theme.dart';
import '../../utils/my_logger.dart';

class ArticleBodyHtml extends StatelessWidget {
  final String htmlData;
  ArticleBodyHtml(this.htmlData);
  String htmlData1 =
      '''<h1> Title <em>important</em> <a>link</a> <span>span</span></h1> 
      <p> paragraph <em>important</em> <a>link</a> <span>span</span></p>''';

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData1,
      style: {
        "h1": Style(
          color: MyColors.black,
          fontSize: FontSize(21.5),
          fontFamily: 'Song',
          letterSpacing: 2,
        ),
        "a": Style(
          color: MyColors.deepBlue,
        ),
        "em": Style(
          color: MyColors.error,
        ),
        "span": Style(
          color: MyColors.suceess,
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
