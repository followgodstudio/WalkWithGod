import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../screens/article_screen/article_screen.dart';
import '../providers/article/article_provider.dart';
import '../configurations/theme.dart';
import '../utils/utils.dart';

class ArticleCard extends StatelessWidget {
  final ArticleProvider article;
  final double aspectRatio;

  ArticleCard(this.article, this.aspectRatio);
  @override
  Widget build(BuildContext context) {
    Future<ui.Image> _getImage(String imgUrl) {
      Completer<ui.Image> completer = new Completer<ui.Image>();
      NetworkImage(imgUrl).resolve(new ImageConfiguration()).addListener(
          ImageStreamListener(
              (ImageInfo info, bool _) => completer.complete(info.image)));
      return completer.future;
    }

    NetworkImage backgroundImage = NetworkImage(article.imageUrl);
    Color textColor = Colors.black;

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 12.5),
        child: Hero(
            tag: article.id,
            child: FutureBuilder(
              future: _getImage(article.imageUrl),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return AspectRatio(
                    aspectRatio: aspectRatio,
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
                                NetworkImage(article.imageUrl)),
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
                                  textColor = snapshot.data
                                      ? Colors.white
                                      : Colors.black;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2.0),
                                        child: Text(
                                          article.title ?? "",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: "Jinling",
                                              color: textColor,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Divider(
                                        color: textColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.0, bottom: 4.0),
                                        child: Row(
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
                                                        NetworkImage(
                                                            article.icon),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Expanded(
                                              child: Text(
                                                article.author ?? "匿名",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "LantingXianHei",
                                                    color: textColor,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                            },
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
            )),
      ),
    );
  }
}
