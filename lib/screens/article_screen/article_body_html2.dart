import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';

class ArticleBodyHtml2 extends StatelessWidget {
  final String htmlData;
  ArticleBodyHtml2(this.htmlData);

  @override
  Widget build(BuildContext context) {
    return EasyWebView(
      src: htmlData,
      isHtml: true, // Use Html syntax
      isMarkdown: false, // Use markdown syntax
      convertToWidgets: false, // Try to convert to flutter widgets
      widgetsTextSelectable: true,
      height: 1000.0,
    );
  }
}
