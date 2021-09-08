import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configurations/theme.dart';
import '../providers/article/article_provider.dart';
import '../screens/article_screen/article_screen.dart';
import '../utils/utils.dart';
import 'network_manager.dart';

enum ArticleCardStyle { small, home, title }

/// Takes the max size that's available
class ArticleCard extends StatelessWidget {
  final ArticleProvider article;
  final ArticleCardStyle style;
  final double aspectRatio;
  ArticleCard({
    this.article,
    this.style = ArticleCardStyle.small,
    this.aspectRatio = 6 / 7,
  });

  @override
  Widget build(BuildContext context) {
    double textPadding = 20.0;
    double space = 8.0;
    int maxLines = 2;
    double avatarRadius = 15;
    String heroTag = article.id;
    double shadowOpacity = 0.3;
    if (style == ArticleCardStyle.small) {
      textPadding = 10.0;
      space = 3.0;
      maxLines = 3;
      avatarRadius = 10;
      heroTag += "_";
    } else if (style == ArticleCardStyle.title) {
      shadowOpacity = 0.0;
      textPadding = 30.0;
    }
    Widget imagePlaceholder = Container(
        decoration: BoxDecoration(color: Theme.of(context).buttonColor));
    Color fontColor = Colors.white;
    TextStyle captionStyle =
        Theme.of(context).textTheme.caption.copyWith(color: fontColor);
    return Hero(
      tag: heroTag,
      child: ChangeNotifierProvider.value(
        value: article,
        child: TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {
            if (style == ArticleCardStyle.small) {
              Navigator.of(context).pushNamed(
                ArticleScreen.routeName,
                arguments: {'articleId': article.id},
              );
            } else if (style == ArticleCardStyle.home) {
              Navigator.of(context).push(PageRouteBuilder(
                fullscreenDialog: true,
                // transitionDuration: Duration(milliseconds: 800),
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
                            color: MyColors.grey.withOpacity(shadowOpacity),
                            spreadRadius: 2,
                            blurRadius: 20,
                            offset: Offset(0, 10)),
                      ],
                    ),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color.fromARGB(210, 0, 0, 0)
                          ],
                        ).createShader(Rect.fromLTRB(
                            0, rect.height * 0.33, rect.width, rect.height));
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
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                VerticalDivider(
                                  indent: 4,
                                  thickness: 4,
                                  color: MyColors.yellow,
                                  width: 4,
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (style != ArticleCardStyle.small)
                                      Consumer<ArticleProvider>(
                                          builder: (context, article, child) {
                                        return Text(
                                            getCreatedDuration(
                                                    article.createdDate) +
                                                " ｜ " +
                                                article.readCount.toString() +
                                                "次观看",
                                            style: captionStyle);
                                      }),
                                    Text(
                                      article.title ?? "",
                                      maxLines: maxLines,
                                      style: (style == ArticleCardStyle.small)
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline3
                                              .copyWith(color: fontColor)
                                          : Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(color: fontColor),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          if (style != ArticleCardStyle.small)
                            SizedBox(height: space),
                          Divider(color: fontColor),
                          if (style != ArticleCardStyle.small)
                            SizedBox(height: space),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    (article.icon == null ||
                                            article.icon.isEmpty)
                                        ? Icon(Icons.album,
                                            color: fontColor, size: 30)
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
                              if (style != ArticleCardStyle.small)
                                Text("已关注", style: captionStyle),
                            ],
                          ),
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
