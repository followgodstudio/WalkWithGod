import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../configurations/theme.dart';
import '../../article_screen/article_screen.dart';
import 'package:provider/provider.dart';
import '../../../providers/article/articles_provider.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({
    Key key,
    @required this.textColor,
    this.firestore,
  }) : super(key: key);

  final Firestore firestore;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final articlesData = Provider.of<ArticlesProvider>(context);

    return SliverFixedExtentList(
      itemExtent: MediaQuery.of(context).size.width,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12.5),
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(articlesData.articles[index].imageUrl ==
                            null
                        ? "https://blog.sevenponds.com/wp-content/uploads/2018/12/800px-Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_454045.jpg"
                        : articlesData.articles[index].imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticleScreen()),
                      );
                    },
                    child: Container(
                        child: Stack(children: [
                      Positioned(
                        bottom: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Container(
                              width: 300,
                              child: Text(
                                articlesData.articles[index].title,
                                style: TextStyle(
                                    fontFamily: "Jinling", color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                articlesData.articles[index].description,
                                style: Theme.of(context)
                                    .textTheme
                                    .captionSmallWhite,
                              ),
                            ),
                            Divider(
                              thickness: 20.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 20.0,
                              child: Center(
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(
                                      start: 1.0, end: 1.0),
                                  height: 5.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.bookmark_border,
                                    color: Colors.white,
                                    size: Theme.of(context)
                                        .textTheme
                                        .captionMedium1
                                        .fontSize),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  articlesData.articles[index].author,
                                  style: Theme.of(context)
                                      .textTheme
                                      .captionMediumWhite,
                                ),
                                SizedBox(
                                  width: 150.0,
                                ),
                                Text(
                                  DateTime.now()
                                      .toUtc()
                                      .difference(articlesData
                                          .articles[index].createdDate)
                                      .inHours
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .captionMediumWhite,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      )
                    ])))),
          );
        },
      ),
    );
  }
}
