import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/configurations/theme.dart';
import 'package:walk_with_god/providers/articles.dart';
import 'package:walk_with_god/screens/LoginScreen.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/PersonalManagementScreen.dart';
import './screens/LoginScreen.dart';
import 'screens/TempScreen.dart';
import 'screens/HomeScreen/HomeScreen.dart';
import 'package:walk_with_god/screens/MainScreen.dart';
import 'screens/TextStyleGuideScreen.dart';

import './configurations/theme.dart';
import './providers/AuthProvider.dart';
import './screens/LoginScreen.dart';
import './screens/MainScreen.dart';
import './screens/EmailAuthScreen/EmailAuthScreen.dart';
import './screens/LoadingScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Articles(),
          //create: (ctx, articles) => Articles(articles),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Walk With God',
          debugShowCheckedModeBanner: false,
          theme: dayTheme,
          home: StreamBuilder<String>(
              stream: auth.onAuthStateChanged,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final bool isLoggedIn = snapshot.hasData;
                  return isLoggedIn ? HomeScreen() : EmailAuthScreen();
                }
                return LoadingScreen();
              }),
          routes: {
            //LoginScreengi.routeName: (ctx) => LoginScreen(),
            //SignupScreen.routeName: (ctx) => SignupScreen(),
            EmailAuthScreen.routeName: (ctx) => EmailAuthScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            MainScreen.routeName: (ctx) => MainScreen(),
          },
        ),
      ),
    );
  }
}
