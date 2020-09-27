import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../configurations/theme.dart';
import '../providers/article/articles_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/splash_provider.dart';
import '../providers/user/profile_provider.dart';
import '../screens/auth_screen/signup_screen.dart';
import 'home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StatefulWidget nextScreen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //getNextScreen();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => nextScreen));
  }

  void getNextScreen() {
    //StatefulWidget _screen;

    // var _userId =
    //     Provider.of<AuthProvider>(context, listen: false).onAuthStateChanged;
    // _userId.listen((event) {
    //   nextScreen = event == null
    //       ? HomeScreen()
    //       : SignupScreen(
    //           authFormType: AuthFormType.signIn,
    //         );
    // });

    // _screen
    // if(_userId != null){

    //}
    Builder(builder: (context) {
      BuildContext rootContext = context;

      return StreamBuilder<String>(
          stream: Provider.of<AuthProvider>(rootContext, listen: true)
              .onAuthStateChanged,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final bool isLoggedIn = snapshot.hasData;
              nextScreen = isLoggedIn
                  ? HomeScreen()
                  : SignupScreen(
                      authFormType: AuthFormType.signIn,
                    );
            }
            return nextScreen;
          });
    });

    //return nextScreen;
  }

  @override
  Widget build(BuildContext context) {
    print("SplashScreen");
    return Builder(builder: (context) {
      BuildContext rootContext = context;
      return StreamBuilder<String>(
          stream: Provider.of<AuthProvider>(rootContext, listen: false)
              .onAuthStateChanged,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState != ConnectionState.active)
              return Center(child: CircularProgressIndicator());
            final bool isLoggedIn = snapshot.hasData;
            nextScreen = isLoggedIn
                ? HomeScreen()
                : SignupScreen(
                    authFormType: AuthFormType.signIn,
                  );
            String uid =
                Provider.of<AuthProvider>(context, listen: false).currentUser;
            if (uid == null) {
              uid = Provider.of<AuthProvider>(context, listen: false)
                  .singInAnonymously();
            }
            return Scaffold(
              body: SafeArea(
                  child: FutureBuilder(
                      future: Future.wait([
                        Provider.of<ArticlesProvider>(context, listen: false)
                            .fetchArticlesByDate(new DateTime.utc(1989, 11, 9)),
                        Provider.of<ProfileProvider>(context, listen: false)
                            .fetchAllUserInfo(uid),
                        Provider.of<SplashProvider>(context)
                            .fetchSplashScreensData(),
                      ]),
                      builder: (ctx, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (asyncSnapshot.error != null) {
                            return Center(
                              child: FlatButton(
                                  onPressed: () {},
                                  child: Text('An error occurred!')),
                            );
                          } else {
                            return Consumer<SplashProvider>(
                                builder: (context, value, child) => FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  nextScreen));
                                    },
                                    child: Column(children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 4.0),
                                          child: Center(
                                            child: Material(
                                                elevation: 5.0,
                                                child: CachedNetworkImage(
                                                    imageUrl: value.imageUrl)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: Text(
                                              value.content,
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
                                              value.author + " 作品 ",
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
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            nextScreen));
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
                                    ])));
                          }
                        }
                      })),
            );
          });
    });
  }
}
