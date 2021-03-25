import 'package:flutter/material.dart';

import '../configurations/theme.dart';
import '../providers/article/article_provider.dart';

class ArticleParagraph extends StatelessWidget {
  final Paragraph _paragraph;
  ArticleParagraph(this._paragraph);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (_paragraph.subtitle != null && _paragraph.subtitle.isNotEmpty)
          SelectableText(
            _paragraph.subtitle,
            style: Theme.of(context).textTheme.buttonLarge,
          ),
        SizedBox(height: 20.0),
        SelectableText(_paragraph.body,
            style: Theme.of(context).textTheme.bodyText1),
        SizedBox(height: 20.0),
      ]),
    );
  }
}
