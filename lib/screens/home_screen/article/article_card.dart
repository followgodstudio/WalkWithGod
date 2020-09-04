import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../screens/article_screen/article_screen.dart';
import '../../../providers/article/article_provider.dart';
import '../../../configurations/theme.dart';
import '../../../utils/utils.dart';

class ArticleCard extends StatelessWidget {
  ArticleProvider article;
  ArticleCard(ArticleProvider article) {
    this.article = article;
  }
  @override
  Widget build(BuildContext context) {
    //Color textColor = Colors.white;
    //final article = Provider.of<ArticleProvider>(context, listen: false);

    // final backgroundImage = article.imageUrl == null || article.imageUrl.isEmpty
    //     ? AssetImage('assets/images/placeholder.png')
    //     : NetworkImage(article.imageUrl);

    Future<ui.Image> _getImage(String imgUrl) {
      Completer<ui.Image> completer = new Completer<ui.Image>();
      NetworkImage(imgUrl).resolve(new ImageConfiguration()).addListener(
          ImageStreamListener(
              (ImageInfo info, bool _) => completer.complete(info.image)));
      return completer.future;
    }

    NetworkImage backgroundImage = NetworkImage(article.imageUrl);

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
        child: Hero(
            tag: article.id,
            child: FutureBuilder(
              future: _getImage(article.imageUrl),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  ui.Image image = snapshot.data;
                  return AspectRatio(
                    aspectRatio: 7 / 8,
                    child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              blurRadius:
                                  25.0, // has the effect of softening the shadow
                              spreadRadius:
                                  0.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, // horizontal, move right 10
                                7.5, // vertical, move down 10
                              ),
                            )
                          ],
                          image: DecorationImage(
                              image: backgroundImage, fit: BoxFit.cover
                              // image.height > image.width
                              //     ? BoxFit.fitWidth
                              //     : BoxFit.fitHeight
                              ),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              ArticleScreen.routeName,
                              arguments: article.id,
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
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: SizedBox()),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text(
                                            article.title ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Jinling",
                                                color: snapshot.data
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 24),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 3.0),
                                          child: Text(
                                            article.description ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "LantingXianHei",
                                                color: snapshot.data
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              article.icon == null ||
                                                      article.icon.isEmpty
                                                  ? Icon(Icons.album)
                                                  : Image(
                                                      image: NetworkImage(
                                                        article.icon,
                                                      ),
                                                      width: 30,
                                                      height: 30,
                                                      color: null,
                                                      fit: BoxFit.scaleDown,
                                                      alignment:
                                                          Alignment.center,
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
                                                      color: snapshot.data
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              Text(
                                                getCreatedDuration(
                                                    article.createdDate ??
                                                        DateTime.now().toUtc()),
                                                style: TextStyle(
                                                    fontFamily:
                                                        "LantingXianHei",
                                                    color: snapshot.data
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 12),
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
                        )),
                  );
                } else {
                  return new Text('Loading...');
                }
              },
            )),
      ),
    );
  }
}
