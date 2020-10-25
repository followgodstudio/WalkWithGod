import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../configurations/theme.dart';
import '../providers/article/article_provider.dart';
import '../screens/article_screen/article_screen.dart';
import '../utils/utils.dart';
import 'network_manager.dart';

/// Takes the max size that's available
class ArticleCard extends StatelessWidget {
  final ArticleProvider article;
  final bool isSmall;
  final double aspectRatio;
  ArticleCard({
    this.article,
    this.isSmall = true,
    this.aspectRatio = 6 / 7,
  });

  @override
  Widget build(BuildContext context) {
    double textPadding = 20.0;
    double space = 8.0;
    int maxLines = 2;
    double titleFontSize = 24;
    double avatarRadius = 15;
    double eyebrowWidth = 42;
    String heroTag = article.id;
    if (isSmall) {
      textPadding = 10.0;
      space = 3.0;
      maxLines = 3;
      titleFontSize = 16;
      avatarRadius = 10;
      eyebrowWidth = 30;
      heroTag += "_";
    }
    Widget imagePlaceholder = Container(
        decoration: BoxDecoration(color: Theme.of(context).buttonColor));
    Color fontColor = Colors.white;
    TextStyle captionStyle =
        TextStyle(fontFamily: "LantingXianHei", color: fontColor, fontSize: 12);
    return Hero(
      tag: heroTag,
      child: FlatButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          if (isSmall) {
            Navigator.of(context).pushNamed(
              ArticleScreen.routeName,
              arguments: {'articleId': article.id},
            );
          } else {
            Navigator.of(context).push(PageRouteBuilder(
              fullscreenDialog: true,
              transitionDuration: Duration(milliseconds: 800),
              pageBuilder: (context, animaton, secondaryAnimtaion) {
                return NetworkManager(child: ArticleScreen());
              },
              settings: RouteSettings(
                name: ArticleScreen.routeName,
                arguments: {'articleId': article.id},
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
          }
        },
        child: Stack(
          children: [
            AspectRatio(
                aspectRatio: aspectRatio,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: MyColors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 20,
                          offset: Offset(10, 10)),
                    ],
                  ),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black38],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.darken,
                    child: (article.imageUrl == null)
                        ? imagePlaceholder
                        : CachedNetworkImage(
                            imageUrl: article.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => imagePlaceholder,
                            errorWidget: (context, url, error) =>
                                imagePlaceholder),
                  ),
                )),
            AspectRatio(
                aspectRatio: aspectRatio,
                child: Padding(
                    padding: EdgeInsets.all(textPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: eyebrowWidth,
                          child:
                              Divider(color: MyColors.yellow, thickness: 4.0),
                        ),
                        if (!isSmall) SizedBox(height: 5.0),
                        Text(
                          article.title ?? "",
                          maxLines: maxLines,
                          style: TextStyle(
                              fontFamily: "Jinling",
                              color: fontColor,
                              fontSize: titleFontSize),
                        ),
                        if (!isSmall) SizedBox(height: space),
                        if (!isSmall)
                          Text(
                            article.description ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: captionStyle,
                          ),
                        Divider(color: fontColor),
                        if (!isSmall) SizedBox(height: space),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  (article.icon == null || article.icon.isEmpty)
                                      ? Icon(Icons.album, color: fontColor)
                                      : CircleAvatar(
                                          radius: avatarRadius,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  article.icon),
                                          backgroundColor: Colors.transparent,
                                        ),
                                  SizedBox(width: space),
                                  Flexible(
                                    child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          article.authorName ?? "匿名",
                                          style: captionStyle,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            if (!isSmall)
                              Text(getCreatedDuration(article.createdDate),
                                  style: captionStyle),
                          ],
                        ),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
