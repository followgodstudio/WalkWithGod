import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/articles_provider.dart';

class TopBar extends StatelessWidget {
  final String articleId;
  TopBar(this.articleId);
  @override
  Widget build(BuildContext context) {
    final loadedArticle = Provider.of<ArticlesProvider>(
      context,
      listen: false,
    ).findById(articleId);
    return SliverAppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            loadedArticle.title ?? "",
            style: Theme.of(context).textTheme.headerSmall1,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              loadedArticle.publisher ?? "随行",
              style: Theme.of(context).textTheme.captionSmall2,
            ),
            Container(
                height: 10,
                child:
                    VerticalDivider(color: Color.fromARGB(255, 128, 128, 128))),
            Text(
              loadedArticle.author ?? "匿名",
              style: Theme.of(context).textTheme.captionSmall2,
            ),
          ],
        ),
      ]),
      floating: true,
      expandedHeight: 50,
      actions: [
        Placeholder(
          color: Theme.of(context).appBarTheme.color,
          fallbackWidth: 60,
        ),
      ],
    );
  }
}
