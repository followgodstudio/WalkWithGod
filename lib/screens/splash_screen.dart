import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/providers/user/profile_provider.dart';

import '../configurations/theme.dart';
import '../providers/article/articles_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/splash_provider.dart';
import 'home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeHomeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StatefulWidget nextScreen;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 8);
    _timer = Timer(duration, routeHome);
  }

  void routeHome() {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    print("SplashScreen");
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: true);
    return StreamBuilder<String>(
        stream: auth.onAuthStateChanged,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState != ConnectionState.active)
            return Center(child: CircularProgressIndicator());
          String uid = auth.currentUser;
          print("User ID: " + (uid == null ? "Anonymous" : uid));
          Provider.of<ProfileProvider>(context, listen: false)
              .fetchAllUserData(uid);
          Provider.of<ArticlesProvider>(context, listen: false)
              .fetchArticlesByDate(new DateTime.utc(1989, 11, 9));
          SplashProvider splash =
              Provider.of<SplashProvider>(context, listen: false);
          //TODO: change FutureBuilder to Consumer
          return Scaffold(
              body: SafeArea(
                  child: FutureBuilder(
                      future: splash.fetchSplashScreensData(),
                      builder: (ctx, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());
                        if (asyncSnapshot.error != null)
                          return Center(child: Text('An error occurred!'));
                        return FlatButton(
                            onPressed: () {
                              _timer.cancel();
                              routeHome();
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 4.0),
                                    child: Center(
                                        child: Material(
                                      elevation: 5.0,
                                      child: CachedNetworkImage(
                                        imageUrl: splash.imageUrl,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                          strokeWidth: 1.0,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    )),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Text(
                                        splash.content,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .captionSmall1,
                                      ),
                                    ),
                                    Divider(
                                      indent: 8.0,
                                      endIndent: 8.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Text(
                                        splash.author + " 作品 ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .captionSmall1,
                                      ),
                                    ),
                                  ]),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 50,
                                      child: Image.asset(
                                          "assets/images/app_logo.png"),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                    Container(
                                        height: 10,
                                        child: VerticalDivider(
                                            color: Color.fromARGB(
                                                255, 128, 128, 128))),
                                    FlatButton(
                                        onPressed: () {
                                          _timer.cancel();
                                          routeHome();
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              "进入应用",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .captionSmall1,
                                            ),
                                            Icon(Icons.arrow_right)
                                          ],
                                        ))
                                  ],
                                ),
                                Icon(Icons.arrow_right)
                              ],
                            ));
                      })));
        });
  }
}
