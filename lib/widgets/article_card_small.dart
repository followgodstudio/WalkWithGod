import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../providers/article/article_provider.dart';
import '../screens/article_screen/article_screen.dart';
import '../utils/utils.dart';

class ArticleCard extends StatelessWidget {
  final ArticleProvider article;
  final double aspectRatio;

  ArticleCard(this.article, this.aspectRatio);
  @override
  Widget build(BuildContext context) {
    Future<ui.Image> _getImage(String imgUrl) {
      Completer<ui.Image> completer = new Completer<ui.Image>();
      CachedNetworkImageProvider(imgUrl)
          .resolve(new ImageConfiguration())
          .addListener(ImageStreamListener(
              (ImageInfo info, bool _) => completer.complete(info.image)));
      return completer.future;
    }

    CachedNetworkImageProvider backgroundImage =
        CachedNetworkImageProvider(article.imageUrl);
    Color textColor = Colors.black;

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 12.5),
        child: FutureBuilder(
          future: _getImage(article.imageUrl),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return AspectRatio(
                aspectRatio: aspectRatio,
                child: Material(
                  elevation: 6.0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: backgroundImage, fit: BoxFit.cover),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          ArticleScreen.routeName,
                          arguments: {'articleId': article.id},
                        );
                      },
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FutureBuilder(
                          future: useWhiteTextColor(
                              CachedNetworkImageProvider(article.imageUrl)),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              if (snapshot.error != null) {
                                return Center(
                                  child: Text('An error occurred!'),
                                );
                              } else {
                                textColor =
                                    snapshot.data ? Colors.white : Colors.black;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.title ?? "",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: "Jinling",
                                          color: textColor,
                                          fontSize: 16),
                                    ),
                                    Divider(
                                      color: textColor,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        article.icon == null ||
                                                article.icon.isEmpty
                                            ? Icon(
                                                Icons.album,
                                                color: textColor,
                                              )
                                            : CircleAvatar(
                                                radius: 10,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        article.icon),
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                        SizedBox(width: 5.0),
                                        Expanded(
                                          child: Text(
                                            article.authorName ?? "匿名",
                                            style: TextStyle(
                                                fontFamily: "LantingXianHei",
                                                color: textColor,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.0),
                                  ],
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                  backgroundColor: Colors.black87,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
