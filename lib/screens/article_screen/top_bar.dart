import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/article_provider.dart';
import '../../utils/my_logger.dart';
import '../../widgets/navbar.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").v("TopBar-build");
    return NavBar(
        isSliverAppBar: true,
        pinned: false,
        titleWidget:
            Consumer<ArticleProvider>(builder: (context, article, child) {
          if (article.id == null) return SizedBox();
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  article.title ?? "",
                  style: Theme.of(context).textTheme.headline4,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      article.publisher ?? "随行",
                      style: Theme.of(context).textTheme.captionSmall,
                    ),
                    Container(
                        height: 10,
                        child: VerticalDivider(color: MyColors.grey)),
                    Flexible(
                      child: Text(
                        article.authorName ?? "匿名",
                        style: Theme.of(context).textTheme.captionSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ]);
        }));
  }
}
