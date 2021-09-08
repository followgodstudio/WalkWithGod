import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configurations/constants.dart';
import '../configurations/theme.dart';
import '../providers/article/articles_provider.dart';
import '../providers/splash_provider.dart';
import '../providers/user/notification_provider.dart';
import '../providers/user/profile_provider.dart';
import '../utils/my_logger.dart';
import '../utils/utils.dart';
import '../widgets/my_progress_indicator.dart';
import 'home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    startTime();
    loadData();
  }

  loadData() {
    exceptionHandling(context, () async {
      await Provider.of<SplashProvider>(context, listen: false)
          .fetchSplashScreensData();
      await Provider.of<ArticlesProvider>(context, listen: false)
          .fetchArticlesByDate();
      await Provider.of<ProfileProvider>(context, listen: false)
          .fetchAllUserData();
      Provider.of<NotificationProvider>(context, listen: false)
          .initNotification();
    });
  }

  startTime() {
    _timer = Timer(Duration(seconds: 8), routeHome);
  }

  void routeHome() {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    MyLogger("Widget").i("SplashScreen-build");
    return Scaffold(body: SafeArea(
        child: Consumer<SplashProvider>(builder: (context, splash, child) {
      if (splash.imageUrl == null) return MyProgressIndicator();
      return TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {
            _timer.cancel();
            routeHome();
          },
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Center(
                      child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: MyColors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 20,
                            offset: Offset(10, 10)),
                      ],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: splash.imageUrl,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )),
                ),
              ),
              Container(
                width: 200,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      splash.content,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.captionSmall,
                    ),
                  ),
                  Divider(
                    indent: 8.0,
                    endIndent: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      splash.author + " 作品 ",
                      style: Theme.of(context).textTheme.captionSmall,
                    ),
                  ),
                ]),
              ),
              Row(
                children: [
                  Container(
                    width: 140,
                    height: 70,
                    child: Image.asset("assets/images/app_logo.png"),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                      height: 20, child: VerticalDivider(color: MyColors.grey)),
                  TextButton(
                      onPressed: () {
                        _timer.cancel();
                        routeHome();
                      },
                      child: Row(
                        children: [
                          Text(
                            "进入应用",
                            style: Theme.of(context).textTheme.captionSmall,
                          ),
                          Icon(Icons.arrow_right)
                        ],
                      ))
                ],
              ),
            ],
          ));
    })));
  }
}
