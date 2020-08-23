import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk_with_god/configurations/theme.dart';
import 'package:walk_with_god/screens/LoginScreen.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/PersonalManagementScreen.dart';
import './screens/LoginScreen.dart';
import 'screens/HomeScreen.dart';
import 'package:walk_with_god/screens/MainScreen.dart';
import 'screens/TextStyleGuideScreen.dart';

import './screens/EmailAuthScreen/EmailAuthScreen.dart';
import './screens/LoadingScreen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Auth(),
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Walk With God',
          debugShowCheckedModeBanner: false,
          theme: dayTheme,
          home: auth.isAuth
              ? MainScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? LoadingScreen()
                          : EmailAuthScreen()),
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
