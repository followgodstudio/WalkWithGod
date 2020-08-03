import 'package:flutter/material.dart';
import 'package:walk_with_god/configurations/theme.dart';
import 'package:walk_with_god/screens/LoginScreen.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/PersonalManagementScreen.dart';
import './screens/LoginScreen.dart';
import 'screens/HomeScreen.dart';
import 'package:walk_with_god/screens/MainScreen.dart';
import 'screens/TextStyleGuideScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walk With God',
      debugShowCheckedModeBanner: false,
      theme: dayTheme,
      home: LoginScreen(),
      routes: {
        //LoginScreengi.routeName: (ctx) => LoginScreen(),
        //SignupScreen.routeName: (ctx) => SignupScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        MainScreen.routeName: (ctx) => MainScreen(),
      },
    );
  }
}
