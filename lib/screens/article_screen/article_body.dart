import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configurations/theme.dart';
import '../../providers/article/article_provider.dart';
import '../../screens/personal_management_screen/headline/network_screen.dart';
import '../../utils/my_logger.dart';
import '../../utils/utils.dart';
import '../../widgets/aricle_paragraph.dart';

class ArticleBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").v("ArticleBody-build");
    return Consumer<ArticleProvider>(builder: (context, article, child) {
      if (article.id == null) return SizedBox();
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Hero(
          tag: 'background' + article.id,
          child: Container(
            height: 200,
            child: Stack(
              children: <Widget>[
                Center(
                  child: FadeInImage(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    placeholder: AssetImage('assets/images/placeholder.png'),
                    image: (article.imageUrl == null || article.imageUrl == "")
                        ? AssetImage('assets/images/placeholder.png')
                        : CachedNetworkImageProvider(article.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10),
          child: Hero(
            tag: 'testing' + article.id,
            child: Material(
              color: Colors.transparent,
              child: SelectableText(
                article.title ?? "",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 3, right: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              article.icon == null || article.icon.isEmpty
                  ? Hero(tag: 'icon' + article.id, child: Icon(Icons.album))
                  : Hero(
                      tag: 'icon' + article.id,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            NetworkScreen.routeName,
                            arguments: article.authorUid,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: CircleAvatar(
                              radius: 12.0,
                              backgroundColor: Theme.of(context).canvasColor,
                              backgroundImage:
                                  CachedNetworkImageProvider(article.icon)),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: SelectableText(
                  article.publisher ?? "随行",
                  style: Theme.of(context).textTheme.captionSmall2,
                ),
              ),
              Container(
                  height: 12,
                  child: VerticalDivider(
                      color: Color.fromARGB(255, 128, 128, 128))),
              Expanded(
                child: Hero(
                  tag: 'authorName' + article.id,
                  child: Material(
                    color: Colors.transparent,
                    child: SelectableText(
                      article.authorName ?? "匿名",
                      style: Theme.of(context).textTheme.captionSmall2,
                    ),
                  ),
                ),
              ),
              Text(
                getCreatedDuration(article.createdDate),
                style: Theme.of(context).textTheme.captionSmall2,
              ),
            ],
          ),
        ),
        Divider(),
        Center(
            child: Column(
                children: [...article.content.map((e) => ArticleParagraph(e))]))
      ]);
    });
  }
}
