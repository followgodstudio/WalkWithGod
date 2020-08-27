import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walk_with_god/model/Comment.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/PersonalManagementScreen.dart';
import 'package:walk_with_god/widgets/aricle_paragraph.dart';
import '../widgets/slide_item.dart';
import '../model/Slide.dart';
import '../widgets/slide_dots.dart';
import '../widgets/comment.dart' as widget;
import 'SignupScreen.dart';
import 'package:intl/date_time_patterns.dart';

class ArticleScreen extends StatefulWidget {
  static const routeName = '/article_screen';
  @override
  _ArticleScreen createState() => _ArticleScreen();
}

class _ArticleScreen extends State<ArticleScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            //width: MediaQuery.of(context).size.width * 160 / 188,
            child: Center(
              child: Column(children: [
                Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: [
                          // Image.network(
                          //     "https://blog.sevenponds.com/wp-content/uploads/2018/12/800px-Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_454045.jpg"),
                          Text("只要互联网还在，我就不会停止敲打键盘"),
                          Row(
                            children: [
                              Text("海外校园"),
                              VerticalDivider(
                                color: Colors.black,
                                thickness: 2,
                                width: 20,
                                indent: 200,
                                endIndent: 200,
                              ),
                              Text("范学德"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(children: <Widget>[
                    ...slideList[_currentPage].content.map(
                        (e) => Column(children: <Widget>[ArticleParagraph(e)])),
                  ]),
                ),
              ]),
            ),

            // Container(
            //   height: 500,
            //   // height: MediaQuery.of(context).size.height -
            //   //     MediaQuery.of(context).padding.top,
            //   child: Padding(
            //     padding: const EdgeInsets.all(10),
            //     child: Column(
            //       children: <Widget>[
            //         Container(
            //           child: Stack(
            //             alignment: AlignmentDirectional.topCenter,
            //             children: <Widget>[
            //               // PageView.builder(
            //               //   scrollDirection: Axis.horizontal,
            //               //   controller: _pageController,
            //               //   onPageChanged: _onPageChanged,
            //               //   itemCount: slideList.length,
            //               //   //itemBuilder: (ctx, i) => SlideItem(i),
            //               //   itemBuilder: (ctx, i) => Text("testing"),
            //               // ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            //Comments(),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
    @required int currentPage,
  })  : _currentPage = currentPage,
        super(key: key);

  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd');
    String formatted = formatter.format(now);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Stack(
          children: [
            Center(
              child: FlatButton(
                  onPressed: () {},
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {},
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 255, 235, 133),
                          ),
                          child: Stack(
                              alignment: AlignmentDirectional.topCenter,
                              children: [
                                Positioned(
                                  top: 3,
                                  child: Text(
                                    DateFormat.MMM().format(DateTime.now()),
                                    style: TextStyle(
                                        fontFamily: 'HelveticaNeue',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Positioned(
                                  top: 16,
                                  child: Text(
                                    formatted,
                                    style: TextStyle(
                                        fontFamily: 'HelveticaNeue',
                                        fontSize: 26,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 35),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (int i = 0; i < slideList.length; i++)
                                  if (i == _currentPage)
                                    SlideDots(true)
                                  else
                                    SlideDots(false)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(Icons.person_outline,
                    size: Theme.of(context).textTheme.button.fontSize),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(PersonalManagementScreen.routeName);
                },
                color: Theme.of(context).accentColor,
                alignment: Alignment.topCenter,
                //padding: const EdgeInsets.only(bottom: ),
              ),
            ),
          ],
        )),
      ],
    );
  }
}

class Comments extends StatelessWidget {
  //List<Comment> commentList;
  Comments({
    Key key,
  }) : super(key: key);
  //Comment(List<Comment> commentList) {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Container(
          height: 500,
          child: ListView.separated(
            itemBuilder: (ctx, i) => widget.Comment(
                i,
                commentList[i].author.user_name,
                commentList[i].author.avatar_url,
                commentList[i].content,
                commentList[i].createdDate,
                commentList[i].number_of_likes,
                commentList[i].list_of_comment),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: commentList.length,
          ),
        ),
      ),
    );
  }
}
