import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../providers/article/article_provider.dart';
import '../../../screens/article_screen/article_screen.dart';
import '../../../utils/utils.dart';

class ArticleCard extends StatelessWidget {
  final ArticleProvider article;
  // final AspectRatio aspectRatio;
  // final Padding padding;

  ArticleCard(this.article) {
    // this.article = article;
    // this.aspectRatio = aspectRatio;
  }
  @override
  Widget build(BuildContext context) {
    //Color textColor = Colors.white;
    //final article = Provider.of<ArticleProvider>(context, listen: false);

    // final backgroundImage = article.imageUrl == null || article.imageUrl.isEmpty
    //     ? AssetImage('assets/images/placeholder.png')
    //     : CachedNetworkImageProvider(article.imageUrl);

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

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
        child: Hero(
            tag: article.id,
            child: FutureBuilder(
              future: _getImage(article.imageUrl),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.error != null) {
                    return Center(
                      child: FlatButton(
                          onPressed: () {}, child: Text('An error occurred!')),
                    );
                  } else {
                    if (snapshot.hasData) {
                      return AspectRatio(
                        aspectRatio: 7 / 8,
                        // child: Stack(
                        //   children: [
                        //     ShaderMask(
                        //         shaderCallback: (rect) {
                        //           return LinearGradient(
                        //             begin: Alignment.topCenter,
                        //             end: Alignment.bottomCenter,
                        //             //colors: [Colors.black, Colors.transparent],
                        //             colors: [
                        //               Colors.transparent,
                        //               Colors.black,
                        //             ],
                        //           ).createShader(
                        //               Rect.fromLTRB(0, 0, rect.width, rect.height));
                        //         },
                        //         blendMode: BlendMode.srcOver,
                        //         child: FittedBox(
                        //             //fit: BoxFit.fitHeight,
                        //             child: Image(
                        //                 image: CachedNetworkImageProvider(article.imageUrl)))
                        //         //AssetImage('assets/images/image0.jpg')),
                        //         ),
                        //     FlatButton(
                        //       onPressed: () {
                        //         Navigator.of(context).pushNamed(
                        //           ArticleScreen.routeName,
                        //           arguments: article.id,
                        //         );
                        //       },
                        //       child: Align(
                        //         alignment: Alignment.bottomCenter,
                        //         child: FutureBuilder(
                        //           future: useWhiteTextColor(
                        //               CachedNetworkImageProvider(article.imageUrl)),
                        //           builder: (BuildContext context,
                        //               AsyncSnapshot<bool> snapshot) {
                        //             if (snapshot.connectionState ==
                        //                 ConnectionState.waiting) {
                        //               return Center(
                        //                 child: CircularProgressIndicator(),
                        //               );
                        //             } else {
                        //               if (snapshot.error != null) {
                        //                 return Center(
                        //                   child: Text('An error occurred!'),
                        //                 );
                        //               } else {
                        //                 return Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: [
                        //                     Expanded(child: SizedBox()),
                        //                     Padding(
                        //                       padding: const EdgeInsets.only(
                        //                           bottom: 8.0),
                        //                       child: Text(
                        //                         article.title ?? "",
                        //                         maxLines: 2,
                        //                         overflow: TextOverflow.ellipsis,
                        //                         style: TextStyle(
                        //                             fontFamily: "Jinling",
                        //                             color: snapshot.data
                        //                                 ? Colors.white
                        //                                 : Colors.black,
                        //                             fontSize: 24),
                        //                       ),
                        //                     ),
                        //                     Padding(
                        //                       padding: const EdgeInsets.symmetric(
                        //                           vertical: 8.0, horizontal: 3.0),
                        //                       child: Text(
                        //                         article.description ?? "",
                        //                         maxLines: 2,
                        //                         overflow: TextOverflow.ellipsis,
                        //                         style: TextStyle(
                        //                             fontFamily: "LantingXianHei",
                        //                             color: snapshot.data
                        //                                 ? Colors.white
                        //                                 : Colors.black,
                        //                             fontSize: 12),
                        //                       ),
                        //                     ),
                        //                     Divider(
                        //                       color: Colors.white,
                        //                     ),
                        //                     Padding(
                        //                       padding: const EdgeInsets.only(
                        //                           top: 8.0, bottom: 20.0),
                        //                       child: Row(
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment.start,
                        //                         children: [
                        //                           article.icon == null ||
                        //                                   article.icon.isEmpty
                        //                               ? Icon(
                        //                                   Icons.album,
                        //                                   color: snapshot.data
                        //                                       ? Colors.white
                        //                                       : Colors.black,
                        //                                 )
                        //                               : Image(
                        //                                   image: CachedNetworkImageProvider(
                        //                                     article.icon,
                        //                                   ),
                        //                                   width: 30,
                        //                                   height: 30,
                        //                                   color: null,
                        //                                   fit: BoxFit.scaleDown,
                        //                                   alignment:
                        //                                       Alignment.center,
                        //                                 ),
                        //                           SizedBox(
                        //                             width: 5.0,
                        //                           ),
                        //                           Expanded(
                        //                             child: Text(
                        //                               article.author ?? "匿名",
                        //                               style: TextStyle(
                        //                                   fontFamily:
                        //                                       "LantingXianHei",
                        //                                   color: snapshot.data
                        //                                       ? Colors.white
                        //                                       : Colors.black,
                        //                                   fontSize: 12),
                        //                             ),
                        //                           ),
                        //                           Text(
                        //                             getCreatedDuration(
                        //                                 article.createdDate ??
                        //                                     DateTime.now().toUtc()),
                        //                             style: TextStyle(
                        //                                 fontFamily:
                        //                                     "LantingXianHei",
                        //                                 color: snapshot.data
                        //                                     ? Colors.white
                        //                                     : Colors.black,
                        //                                 fontSize: 12),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 );
                        //               }
                        //             }
                        //           },
                        //         ),
                        //       ),
                        //     )

                        //   ],
                        // ),

                        // Container(
                        //     decoration: BoxDecoration(
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey[300],
                        //           blurRadius:
                        //               25.0, // has the effect of softening the shadow
                        //           spreadRadius:
                        //               0.0, // has the effect of extending the shadow
                        //           offset: Offset(
                        //             0.0, // horizontal, move right 10
                        //             7.5, // vertical, move down 10
                        //           ),
                        //         )
                        //       ],
                        //       image: DecorationImage(
                        //           image: backgroundImage,
                        //           colorFilter: ColorFilter.mode(
                        //               //snapshot.data
                        //               //? Colors.white.withOpacity(0.8)
                        //               Colors.black.withOpacity(0.8),
                        //               BlendMode.srcOver),
                        //           fit: BoxFit.cover
                        //           // image.height > image.width
                        //           //     ? BoxFit.fitWidth
                        //           //     : BoxFit.fitHeight
                        //           ),
                        //     ),

                        child: Container(
                            decoration: BoxDecoration(
                              backgroundBlendMode: BlendMode.softLight,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.black.withAlpha(0),
                                  //Colors.black12,
                                  Colors.black45
                                ],
                              ),

                              // LinearGradient(
                              //   end: FractionalOffset.topCenter,
                              //   begin: FractionalOffset.bottomCenter,
                              //   colors: [
                              //     Colors.black.withOpacity(0.0),
                              //     Colors.black.withOpacity(0.8),
                              //   ],
                              // ),

                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey[300],
                              //     blurRadius:
                              //         25.0, // has the effect of softening the shadow
                              //     spreadRadius:
                              //         0.0, // has the effect of extending the shadow
                              //     offset: Offset(
                              //       0.0, // horizontal, move right 10
                              //       7.5, // vertical, move down 10
                              //     ),
                              //   )
                              // ],

                              image: DecorationImage(
                                  image: backgroundImage,
                                  // colorFilter: ColorFilter.mode(
                                  //     //snapshot.data
                                  //     //? Colors.white.withOpacity(0.8)
                                  //     Colors.black.withOpacity(0.8),
                                  //     BlendMode.srcOver),
                                  fit: BoxFit.cover
                                  // image.height > image.width
                                  //     ? BoxFit.fitWidth
                                  //     : BoxFit.fitHeight
                                  ),
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
                                      CachedNetworkImageProvider(
                                          article.imageUrl)),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 3.0),
                                              child: Text(
                                                article.description ?? "",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily:
                                                        "LantingXianHei",
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
                                                      ? Icon(
                                                          Icons.album,
                                                          color: snapshot.data
                                                              ? Colors.white
                                                              : Colors.black,
                                                        )
                                                      : CircleAvatar(
                                                          radius: 15,
                                                          backgroundImage:
                                                              CachedNetworkImageProvider(
                                                                  article.icon),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          // width: 30,
                                                          // height: 30,
                                                        ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      article.authorName ??
                                                          "匿名",
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
                                                    getCreatedDuration(article
                                                            .createdDate ??
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
                    }
                    // else {
                    //   return Center(child: CircularProgressIndicator());
                    // }
                  }
                }
              },
            )),
      ),
    );
  }
}
