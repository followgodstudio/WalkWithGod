import 'package:flutter/material.dart';
import 'package:walk_with_god/configurations/theme.dart';
import 'package:walk_with_god/screens/LoginScreen.dart';
import 'package:walk_with_god/screens/PersonalManagementScreen/PersonalManagementScreen.dart';
import './screens/LoginScreen.dart';
import 'screens/HomeScreen/HomeScreen.dart';
import 'package:walk_with_god/screens/MainScreen.dart';
import 'screens/TextStyleGuideScreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'WalkWithGod',
    options: const FirebaseOptions(
      googleAppID: '1:21802022919:android:b9208f68c19ffa4c8092a2',
      gcmSenderID: '21802022919',
      apiKey: 'AIzaSyDZyOqJh06FJbNyq8UrYTeeJTN-wauhnk8',
      projectID: 'walkwithgod-73ee8',
    ),
  );
  final Firestore firestore = Firestore(app: app);

  runApp(MyApp(firestore: firestore));
  //title: 'Walk With God', home: MyHomePage(firestore: firestore)));
}

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({Key key, this.firestore}) : super(key: key);
  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walk With God',
      debugShowCheckedModeBanner: false,
      theme: dayTheme,
      home: HomeScreen(),
      routes: {
        //LoginScreengi.routeName: (ctx) => LoginScreen(),
        //SignupScreen.routeName: (ctx) => SignupScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        MainScreen.routeName: (ctx) => MainScreen(),
        TextStyleGuideScreen.routeName: (ctx) => TextStyleGuideScreen(),
      },
    );
  }
}
