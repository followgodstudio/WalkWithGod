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
import '../configurations/theme.dart';

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
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "只要互联网还在，我就不会停止敲打键盘",
                      style: Theme.of(context).textTheme.headerSmall1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "OC海外校园",
                          style: Theme.of(context).textTheme.captionSmall2,
                        ),
                        Container(
                            height: 10,
                            child: VerticalDivider(
                                color: Color.fromARGB(255, 128, 128, 128))),
                        Text(
                          "范学德",
                          style: Theme.of(context).textTheme.captionSmall2,
                        ),
                      ],
                    ),
                  ]),
              floating: true,
              expandedHeight: 50,
              actions: [
                Placeholder(
                  color: Theme.of(context).appBarTheme.color,
                  fallbackWidth: 40,
                ),
                // Icon(
                //   Icons.arrow_back_ios,
                // ),
              ],
            ),
            // Next, create a SliverList

            SliverToBoxAdapter(
              //padding: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      //width: MediaQuery.of(context).size.width * 160 / 188,
                      //height: 500,
                      //width: MediaQuery.of(context).size.width * 160 / 188,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://blog.sevenponds.com/wp-content/uploads/2018/12/800px-Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_454045.jpg"),
                                fit: BoxFit.cover,
                              ),
                              color: Color.fromARGB(255, 255, 235, 133),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 10),
                            child: Text(
                              "只要互联网还在，我就不会停止敲打键盘",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.ac_unit),
                                Text(
                                  "海外校园",
                                  style:
                                      Theme.of(context).textTheme.captionSmall2,
                                ),
                                Container(
                                    height: 20,
                                    child: VerticalDivider(
                                        color: Color.fromARGB(
                                            255, 128, 128, 128))),
                                Text(
                                  "范学德",
                                  style:
                                      Theme.of(context).textTheme.captionSmall2,
                                ),
                                Text(
                                  "2小时前",
                                  style:
                                      Theme.of(context).textTheme.captionSmall2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Center(
                      child: Column(children: <Widget>[
                        ...slideList[_currentPage].content.map((e) =>
                            Column(children: <Widget>[ArticleParagraph(e)])),
                      ]),
                    ),

                    // Center(
                    //   child: Column(children: <Widget>[
                    //     ...slideList[_currentPage].content.map(
                    //         (e) => Column(children: <Widget>[ArticleParagraph(e)])),
                    //   ]),
                    // ),
                    Comments(),
                  ],
                ),
              ),
            ),
          ],
        ),
        // child: SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.all(20.0),
        //     child: Column(
        //       children: <Widget>[
        //         Container(
        //           //width: MediaQuery.of(context).size.width * 160 / 188,
        //           //height: 500,
        //           //width: MediaQuery.of(context).size.width * 160 / 188,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Container(
        //                 height: 200.0,
        //                 decoration: BoxDecoration(
        //                   image: DecorationImage(
        //                     image: NetworkImage(
        //                         "https://blog.sevenponds.com/wp-content/uploads/2018/12/800px-Vincent_van_Gogh_-_Self-Portrait_-_Google_Art_Project_454045.jpg"),
        //                     fit: BoxFit.cover,
        //                   ),
        //                   color: Color.fromARGB(255, 255, 235, 133),
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 20.0, bottom: 10),
        //                 child: Text(
        //                   "只要互联网还在，我就不会停止敲打键盘",
        //                   style: Theme.of(context).textTheme.headline1,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(bottom: 10.0),
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     Icon(Icons.ac_unit),
        //                     Text(
        //                       "海外校园",
        //                       style: Theme.of(context).textTheme.captionSmall2,
        //                     ),
        //                     Container(
        //                         height: 20,
        //                         child: VerticalDivider(
        //                             color: Color.fromARGB(255, 128, 128, 128))),
        //                     Text(
        //                       "范学德",
        //                       style: Theme.of(context).textTheme.captionSmall2,
        //                     ),
        //                     Text(
        //                       "2小时前",
        //                       style: Theme.of(context).textTheme.captionSmall2,
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         Divider(),
        //         Center(
        //           child: Column(children: <Widget>[
        //             ...slideList[_currentPage].content.map(
        //                 (e) => Column(children: <Widget>[ArticleParagraph(e)])),
        //           ]),
        //         ),

        //         // Center(
        //         //   child: Column(children: <Widget>[
        //         //     ...slideList[_currentPage].content.map(
        //         //         (e) => Column(children: <Widget>[ArticleParagraph(e)])),
        //         //   ]),
        //         // ),
        //         Comments(),
        //       ],
        //     ),
        //   ),
        // ),
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
