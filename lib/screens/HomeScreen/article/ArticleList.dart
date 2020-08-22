import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../configurations/Theme.dart';

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
    // return StreamBuilder<QuerySnapshot>(
    //     stream: firestore
    //         .collection("articles")
    //         .orderBy("created_date", descending: true)
    //         .snapshots(),
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (!snapshot.hasData) return const Text('Loading...');
    //       final int articleCount = snapshot.data.documents.length;
    //       return ListView.builder(
    //         itemCount: articleCount,
    //         itemBuilder: (_, int index) {
    //           final DocumentSnapshot document = snapshot.data.documents[index];
    //           final dynamic message = document['title'];
    //           return ListTile(
    //             trailing: IconButton(
    //               onPressed: () => document.reference.delete(),
    //               icon: Icon(Icons.delete),
    //             ),
    //             title: Text(
    //               message != null
    //                   ? message.toString()
    //                   : '<No message retrieved>',
    //             ),
    //             subtitle: Text('Message ${index + 1} of $articleCount'),
    //           );
    //         },
    //       );
    //     });

    return SliverFixedExtentList(
      itemExtent: MediaQuery.of(context).size.width,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12.5),
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://blog.sevenponds.com/wp-content/uploads/2018/12/800px-Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_454045.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: FlatButton(
                    onPressed: () {},
                    child: Container(
                        child: Stack(children: [
                      Positioned(
                        bottom: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Flexible(
                            //flex: 2,
                            Divider(),
                            Container(
                              width: 300,
                              child: Text(
                                "梵高逝世130年，他的书信仍旧对你我说话",
                                style: TextStyle(
                                    fontFamily: "Jinling", color: textColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "梵高不仅是一位画家，还是一位传道人。",
                                style:
                                    Theme.of(context).textTheme.captionSmall1,
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
                                  "今日佳音",
                                  style: Theme.of(context)
                                      .textTheme
                                      .captionMedium1,
                                ),
                                SizedBox(
                                  width: 150.0,
                                ),
                                Text(
                                  "2小时前",
                                  style: Theme.of(context)
                                      .textTheme
                                      .captionMedium1,
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
