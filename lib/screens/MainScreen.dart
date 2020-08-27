import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/comment.dart';
import '../screens/PersonalManagementScreen/PersonalManagementScreen.dart';
import '../widgets/aricle_paragraph.dart';
import '../widgets/slide_item.dart';
import '../model/slide.dart';
import '../widgets/slide_dots.dart';
import '../widgets/comment.dart' as widget;

class MainScreen extends StatefulWidget {
  static const routeName = '/getting_started';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 500), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Header(currentPage: _currentPage),
                      Expanded(
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: <Widget>[
                            PageView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              itemCount: slideList.length,
                              itemBuilder: (ctx, i) => SlideItem(i),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(children: <Widget>[
                  ...slideList[_currentPage].content.map(
                      (e) => Column(children: <Widget>[ArticleParagraph(e)])),
                ]),
              ),
              Comments(),
            ],
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
