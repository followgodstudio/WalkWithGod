import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './screens/getting_started_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: GettingStartedScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
      },
    );
  }
}
