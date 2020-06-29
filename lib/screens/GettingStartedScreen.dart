import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/slide_item.dart';
import '../model/slide.dart';
import '../widgets/slide_dots.dart';
import 'SignupScreen.dart';
import 'package:intl/date_time_patterns.dart';

class GettingStartedScreen extends StatefulWidget {
  static const routeName = '/getting_started';
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
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
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FlatButton(
                          child: Column(
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  text: DateFormat.MMMd().format(DateTime.now()) +
                                      '  ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: DateFormat.y().format(DateTime.now()),
                                        style: TextStyle(
                                          fontFamily: 'HelveticaNeue',
                                          fontWeight: FontWeight.w200,
                                        )),
                                  ],
                                ),
                                style: TextStyle(
                                  fontFamily: 'HelveticaNeue',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              Stack(
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[
                                  Container(
                                    margin:
                                        const EdgeInsets.only(top: 5, bottom: 15),
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
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: Theme.of(context).appBarTheme.color,
                          //color: Colors.blue,
                          textColor: Theme.of(context).primaryColorDark,
                          onPressed: () {
                            Navigator.of(context).pushNamed(SignupScreen.routeName);
                          },
                        ),
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.only(bottom: 56.0),
                        child: Divider(
                            thickness: 2.0,
                            color: Theme.of(context).primaryColor,
                            indent: 160.0,
                            endIndent: 160.0,
                            height: 0.0)),
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
          
          ],
        ),
      ),
    );
  }
}
