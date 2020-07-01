import 'package:flutter/material.dart';
import 'package:walk_with_god/screens/LoginScreen.dart';
import './screens/LoginScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/MainScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walk With God',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.white),
        textTheme: TextTheme(
          title: TextStyle(
              color: Colors.black87, fontSize: 31.0, fontFamily: 'Song'),
          subtitle: TextStyle(
              color: Colors.black54, fontSize: 28.0, fontFamily: 'Song'),
          caption: TextStyle(
              color: Colors.grey[500], fontSize: 23.0, fontFamily: 'Song'),
          display2: TextStyle(
              color: Colors.grey[500], fontSize: 16.0, fontFamily: 'Song'),
        ),
        accentColor: Colors.grey,
      ),
      home: LoginScreen(),
      routes: {
        //LoginScreen.routeName: (ctx) => LoginScreen(),
        //SignupScreen.routeName: (ctx) => SignupScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        MainScreen.routeName: (ctx) => MainScreen(),
      },
    );
  }
}
