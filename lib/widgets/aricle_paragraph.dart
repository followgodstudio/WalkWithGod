import 'package:flutter/material.dart';

import '../providers/article/article_provider.dart';

class ArticleParagraph extends StatelessWidget {
  final Paragraph _paragraph;
  ArticleParagraph(this._paragraph);

  @override
  Widget build(BuildContext context) {
    print("ArticleParagraph");
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              _paragraph.subtitle == null || _paragraph.subtitle.isEmpty
                  ? Container(
                      width: 30,
                      height: 4,
                      color: Colors.yellow,
                    )
                  : SelectableText(
                      _paragraph.subtitle,
                      style: Theme.of(context).textTheme.subtitle1,
                    )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: SelectableText(_paragraph.body,
              style: Theme.of(context).textTheme.bodyText1),
        ),
      ]),
    );
  }
}
