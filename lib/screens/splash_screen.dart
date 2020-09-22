import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/providers/splash_provider.dart';
import 'package:walk_with_god/screens/auth_screen/signup_screen.dart';
import '../configurations/theme.dart';
import 'home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SignupScreen(
                  authFormType: AuthFormType.signIn,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
              future: Provider.of<SplashProvider>(context).fetchSplashImage(),
              builder: (ctx, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (asyncSnapshot.error != null) {
                    return Center(
                      child: FlatButton(
                          onPressed: () {}, child: Text('An error occurred!')),
                    );
                  } else {
                    return Consumer<SplashProvider>(
                        builder: (context, value, child) => FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
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
                                                    SignupScreen(
                                                      authFormType:
                                                          AuthFormType.signIn,
                                                    )));
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
  }
}
