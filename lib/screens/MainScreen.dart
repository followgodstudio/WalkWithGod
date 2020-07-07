import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walk_with_god/widgets/aricle_paragraph.dart';
import '../widgets/slide_item.dart';
import '../model/slide.dart';
import '../widgets/slide_dots.dart';
import 'SignupScreen.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:http/http.dart' as http;

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
    fetchAndSetArticles();
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

  Future<void> fetchAndSetArticles() async {
    const url = "https://walkwithgod-73ee8.firebaseio.com/articles.json";
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
    } catch (error) {
      throw (error);
    }
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
                  Navigator.of(context).pushNamed(SignupScreen.routeName);
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
