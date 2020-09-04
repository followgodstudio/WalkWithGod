import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configurations/theme.dart';
import '../providers/article/article_provider.dart';
import '../providers/article/articles_provider.dart';
import '../screens/article_screen/article_screen.dart';

class ArticlePreview extends StatelessWidget {
  final String articleId;
  ArticlePreview(this.articleId);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder(
          future: Provider.of<ArticlesProvider>(context, listen: false)
              .fetchArticlePreviewById(articleId),
          builder: (ctx, AsyncSnapshot<ArticleProvider> asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (asyncSnapshot.error != null)
              return Center(
                child: Text('An error occurred!'),
              );
            return FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ArticleScreen.routeName,
                  arguments: articleId,
                );
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 4,
                      color: Colors.yellow,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        asyncSnapshot.data.title ?? "",
                        style: Theme.of(context).textTheme.headerSmall1,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          asyncSnapshot.data.publisher ?? "随行",
                          style: Theme.of(context).textTheme.captionSmall2,
                        ),
                        Container(
                            height: 10,
                            child: VerticalDivider(
                                color: Color.fromARGB(255, 128, 128, 128))),
                        Text(
                          asyncSnapshot.data.author ?? "匿名",
                          style: Theme.of(context).textTheme.captionSmall2,
                        ),
                      ],
                    ),
                  ]),
            );
          }),
    );
  }
}
