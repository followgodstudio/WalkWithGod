import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../providers/article/article_provider.dart';
import '../../../screens/article_screen/article_screen.dart';
import '../../../utils/utils.dart';

class ArticleCard extends StatelessWidget {
  final ArticleProvider article;
  ArticleCard(this.article);

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

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.5),
        child: FutureBuilder(
          future: _getImage(article.imageUrl),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Card(
                  elevation: 8.0,
                  child: AspectRatio(
                      aspectRatio: 7 / 8,
                      child: FittedBox(
                        child: Image.asset("assets/images/placeholder.png"),
                        fit: BoxFit.fill,
                      )));
              // Center(
              //     child: CircularProgressIndicator(
              //   strokeWidth: 1.0,
              // ));
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: FlatButton(
                      onPressed: () {}, child: Text('An error occurred!')),
                );
              } else {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pushNamed(
                      //   ArticleScreen.routeName,
                      //   arguments: {'articleId': article.id},
                      // );

                      Navigator.of(context).push(PageRouteBuilder(
                        fullscreenDialog: true,
                        transitionDuration: Duration(milliseconds: 800),
                        pageBuilder: (context, animaton, secondaryAnimtaion) {
                          return ArticleScreen();
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
                    },
                    child: Card(
                      elevation: 8.0,
                      child: Stack(
                        children: [
                          Hero(
                              tag: 'background' + article.id,
                              child: AspectRatio(
                                aspectRatio: 7 / 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    //backgroundBlendMode: BlendMode.softLight,
                                    image: DecorationImage(
                                        image: backgroundImage,
                                        fit: BoxFit.cover),
                                    // gradient: LinearGradient(
                                    //   begin: Alignment.topCenter,
                                    //   end: Alignment.bottomCenter,
                                    //   colors: <Color>[
                                    //     Colors.black.withAlpha(0),
                                    //     Colors.black12,
                                    //     Colors.black45
                                    //   ],
                                    // ),
                                  ),
                                ),
                              )),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: AspectRatio(
                              aspectRatio: 7 / 8,
                              // child: Container(
                              //   // height: 360,
                              //   // width: _screenWidthAdjustment,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Hero(
                                                    tag: 'title' + article.id,
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: Text(
                                                        article.title ?? "",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Jinling",
                                                            color: snapshot.data
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontSize: 24),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 3.0),
                                                  child: Text(
                                                    article.description ?? "",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          bottom: 0.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      article.icon == null ||
                                                              article
                                                                  .icon.isEmpty
                                                          ? Hero(
                                                              tag: 'icon' +
                                                                  article.id,
                                                              child: Icon(
                                                                Icons.album,
                                                                color: snapshot
                                                                        .data
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            )
                                                          : Hero(
                                                              tag: 'icon' +
                                                                  article.id,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 15,
                                                                backgroundImage:
                                                                    CachedNetworkImageProvider(
                                                                        article
                                                                            .icon),
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                // width: 30,
                                                                // height: 30,
                                                              ),
                                                            ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Expanded(
                                                        child: Hero(
                                                          tag: 'authorName' +
                                                              article.id,
                                                          // //flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) => ,

                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: Text(
                                                              article.authorName ??
                                                                  "匿名",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "LantingXianHei",
                                                                  color: snapshot
                                                                          .data
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        getCreatedDuration(
                                                            article.createdDate ??
                                                                DateTime.now()
                                                                    .toUtc()),
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
                                      })),
                              //),
                            ),
                          )

                          // Positioned(
                          //   top: 100,
                          //   left: 32.0,
                          //   width: _screenWidthAdjustment,
                          //   child: Hero(
                          //     tag: 'title' + article.id,
                          //     child: Text(
                          //       article.title ?? "",
                          //       maxLines: 2,
                          //       overflow: TextOverflow.ellipsis,
                          //       style: TextStyle(
                          //           fontFamily: "Jinling",
                          //           // color: snapshot.data
                          //           //     ? Colors.white
                          //           //     : Colors.black,
                          //           fontSize: 24),
                          //     ),
                          //   ),
                          // ),
                          // Positioned(
                          //     child: Hero(
                          //   tag: 'description' + article.id,
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 8.0, horizontal: 3.0),
                          //     child: Text(
                          //       article.description ?? "",
                          //       maxLines: 2,
                          //       overflow: TextOverflow.ellipsis,
                          //       style: TextStyle(
                          //           fontFamily: "LantingXianHei",
                          //           // color: snapshot.data
                          //           //     ? Colors.white
                          //           //     : Colors.black,
                          //           fontSize: 12),
                          //     ),
                          //   ),
                          // )),
                        ],
                      ),
                    ),
                  );

                  // return AspectRatio(
                  //   aspectRatio: 7 / 8,
                  //   child: Hero(
                  //     tag: article.id,
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //           backgroundBlendMode: BlendMode.softLight,
                  //           gradient: LinearGradient(
                  //             begin: Alignment.topCenter,
                  //             end: Alignment.bottomCenter,
                  //             colors: <Color>[
                  //               Colors.black.withAlpha(0),
                  //               //Colors.black12,
                  //               Colors.black45
                  //             ],
                  //           ),
                  //           image: DecorationImage(
                  //               image: backgroundImage, fit: BoxFit.cover),
                  //         ),
                  //         child: FlatButton(
                  //           onPressed: () {
                  //             Navigator.of(context).pushNamed(
                  //               ArticleScreen.routeName,
                  //               arguments: {'articleId': article.id},
                  //             );
                  //           },
                  //           child: Align(
                  //             alignment: Alignment.bottomCenter,
                  //             child: FutureBuilder(
                  //               future: useWhiteTextColor(
                  //                   CachedNetworkImageProvider(
                  //                       article.imageUrl)),
                  //               builder: (BuildContext context,
                  //                   AsyncSnapshot<bool> snapshot) {
                  //                 if (snapshot.connectionState ==
                  //                     ConnectionState.waiting) {
                  //                   return Center(
                  //                     child: CircularProgressIndicator(),
                  //                   );
                  //                 } else {
                  //                   if (snapshot.error != null) {
                  //                     return Center(
                  //                       child: Text('An error occurred!'),
                  //                     );
                  //                   } else {
                  //                     return Column(
                  //                       mainAxisSize: MainAxisSize.min,
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Expanded(child: SizedBox()),
                  //                         Padding(
                  //                           padding: const EdgeInsets.only(
                  //                               bottom: 8.0),
                  //                           child: Text(
                  //                             article.title ?? "",
                  //                             maxLines: 2,
                  //                             overflow: TextOverflow.ellipsis,
                  //                             style: TextStyle(
                  //                                 fontFamily: "Jinling",
                  //                                 color: snapshot.data
                  //                                     ? Colors.white
                  //                                     : Colors.black,
                  //                                 fontSize: 24),
                  //                           ),
                  //                         ),
                  //                         Padding(
                  //                           padding: const EdgeInsets.symmetric(
                  //                               vertical: 8.0, horizontal: 3.0),
                  //                           child: Text(
                  //                             article.description ?? "",
                  //                             maxLines: 2,
                  //                             overflow: TextOverflow.ellipsis,
                  //                             style: TextStyle(
                  //                                 fontFamily: "LantingXianHei",
                  //                                 color: snapshot.data
                  //                                     ? Colors.white
                  //                                     : Colors.black,
                  //                                 fontSize: 12),
                  //                           ),
                  //                         ),
                  //                         Divider(
                  //                           color: Colors.white,
                  //                         ),
                  //                         Padding(
                  //                           padding: const EdgeInsets.only(
                  //                               top: 8.0, bottom: 20.0),
                  //                           child: Row(
                  //                             mainAxisAlignment:
                  //                                 MainAxisAlignment.start,
                  //                             children: [
                  //                               article.icon == null ||
                  //                                       article.icon.isEmpty
                  //                                   ? Icon(
                  //                                       Icons.album,
                  //                                       color: snapshot.data
                  //                                           ? Colors.white
                  //                                           : Colors.black,
                  //                                     )
                  //                                   : CircleAvatar(
                  //                                       radius: 15,
                  //                                       backgroundImage:
                  //                                           CachedNetworkImageProvider(
                  //                                               article.icon),
                  //                                       backgroundColor:
                  //                                           Colors.transparent,
                  //                                       // width: 30,
                  //                                       // height: 30,
                  //                                     ),
                  //                               SizedBox(
                  //                                 width: 10.0,
                  //                               ),
                  //                               Expanded(
                  //                                 child: Text(
                  //                                   article.authorName ?? "匿名",
                  //                                   style: TextStyle(
                  //                                       fontFamily:
                  //                                           "LantingXianHei",
                  //                                       color: snapshot.data
                  //                                           ? Colors.white
                  //                                           : Colors.black,
                  //                                       fontSize: 12),
                  //                                 ),
                  //                               ),
                  //                               Text(
                  //                                 getCreatedDuration(article
                  //                                         .createdDate ??
                  //                                     DateTime.now().toUtc()),
                  //                                 style: TextStyle(
                  //                                     fontFamily:
                  //                                         "LantingXianHei",
                  //                                     color: snapshot.data
                  //                                         ? Colors.white
                  //                                         : Colors.black,
                  //                                     fontSize: 12),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     );
                  //                   }
                  //                 }
                  //               },
                  //             ),
                  //           ),
                  //         )),
                  //   ),
                  // );

                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
            }
          },
        ),
      ),
    );
  }
}

// return AspectRatio(
//   aspectRatio: 7 / 8,
//   child: Hero(
//     tag: article.id,
//     child: Container(
//         decoration: BoxDecoration(
//           backgroundBlendMode: BlendMode.softLight,
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: <Color>[
//               Colors.black.withAlpha(0),
//               //Colors.black12,
//               Colors.black45
//             ],
//           ),
//           image: DecorationImage(
//               image: backgroundImage, fit: BoxFit.cover),
//         ),
//         child: FlatButton(
//           onPressed: () {
//             Navigator.of(context).pushNamed(
//               ArticleScreen.routeName,
//               arguments: {'articleId': article.id},
//             );
//           },
//           child: Align(
//             alignment: Alignment.bottomCenter,
//             child: FutureBuilder(
//               future: useWhiteTextColor(
//                   CachedNetworkImageProvider(
//                       article.imageUrl)),
//               builder: (BuildContext context,
//                   AsyncSnapshot<bool> snapshot) {
//                 if (snapshot.connectionState ==
//                     ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else {
//                   if (snapshot.error != null) {
//                     return Center(
//                       child: Text('An error occurred!'),
//                     );
//                   } else {
//                     return Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment:
//                           CrossAxisAlignment.start,
//                       children: [
//                         Expanded(child: SizedBox()),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               bottom: 8.0),
//                           child: Text(
//                             article.title ?? "",
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 fontFamily: "Jinling",
//                                 color: snapshot.data
//                                     ? Colors.white
//                                     : Colors.black,
//                                 fontSize: 24),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8.0, horizontal: 3.0),
//                           child: Text(
//                             article.description ?? "",
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 fontFamily: "LantingXianHei",
//                                 color: snapshot.data
//                                     ? Colors.white
//                                     : Colors.black,
//                                 fontSize: 12),
//                           ),
//                         ),
//                         Divider(
//                           color: Colors.white,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 8.0, bottom: 20.0),
//                           child: Row(
//                             mainAxisAlignment:
//                                 MainAxisAlignment.start,
//                             children: [
//                               article.icon == null ||
//                                       article.icon.isEmpty
//                                   ? Icon(
//                                       Icons.album,
//                                       color: snapshot.data
//                                           ? Colors.white
//                                           : Colors.black,
//                                     )
//                                   : CircleAvatar(
//                                       radius: 15,
//                                       backgroundImage:
//                                           CachedNetworkImageProvider(
//                                               article.icon),
//                                       backgroundColor:
//                                           Colors.transparent,
//                                       // width: 30,
//                                       // height: 30,
//                                     ),
//                               SizedBox(
//                                 width: 10.0,
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   article.authorName ?? "匿名",
//                                   style: TextStyle(
//                                       fontFamily:
//                                           "LantingXianHei",
//                                       color: snapshot.data
//                                           ? Colors.white
//                                           : Colors.black,
//                                       fontSize: 12),
//                                 ),
//                               ),
//                               Text(
//                                 getCreatedDuration(article
//                                         .createdDate ??
//                                     DateTime.now().toUtc()),
//                                 style: TextStyle(
//                                     fontFamily:
//                                         "LantingXianHei",
//                                     color: snapshot.data
//                                         ? Colors.white
//                                         : Colors.black,
//                                     fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                 }
//               },
//             ),
//           ),
//         )),
//   ),
// );
