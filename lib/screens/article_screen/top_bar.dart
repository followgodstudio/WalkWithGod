import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/article_provider.dart';
import '../../utils/my_logger.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").v("TopBar-build");
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
        floating: true,
        expandedHeight: 50,
        actions: [
          Placeholder(
            color: Theme.of(context).appBarTheme.color,
            fallbackWidth: 60,
          ),
        ],
        title: Consumer<ArticleProvider>(builder: (context, article, child) {
          if (article.id == null) return SizedBox();
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    article.title ?? "",
                    style: Theme.of(context).textTheme.headerSmall1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      article.publisher ?? "随行",
                      style: Theme.of(context).textTheme.captionSmall2,
                    ),
                    Container(
                        height: 10,
                        child: VerticalDivider(
                            color: Color.fromARGB(255, 128, 128, 128))),
                    Text(
                      article.authorName ?? "匿名",
                      style: Theme.of(context).textTheme.captionSmall2,
                    ),
                  ],
                ),
              ]);
        }));
  }
}
