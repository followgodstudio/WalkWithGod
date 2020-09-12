import 'package:flutter/material.dart';
import '../providers/article/article_provider.dart';
// import '../model/slide.dart';

class ArticleParagraph extends StatelessWidget {
  Paragraph _paragraph;

  ArticleParagraph(Paragraph paragraph) {
    this._paragraph = paragraph;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      width: MediaQuery.of(context).size.width * 160 / 188,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              _paragraph.subtitle == null
                  ? Container(
                      width: 30,
                      height: 4,
                      color: Colors.yellow,
                    )
                  : Text(
                      _paragraph.subtitle,
                      style: Theme.of(context).textTheme.subtitle1,
                    )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(_paragraph.body,
              style: Theme.of(context).textTheme.bodyText1),
        ),
      ]),
    );
  }
}
