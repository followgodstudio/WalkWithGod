import 'package:flutter/material.dart';

final ThemeData dayTheme = new ThemeData(
  primarySwatch: Colors.deepOrange,
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(color: Colors.white),
  textTheme: TextTheme(
    title: TextStyle(color: Colors.black87, fontSize: 31.0, fontFamily: 'Song'),
    subtitle:
        TextStyle(color: Colors.black54, fontSize: 28.0, fontFamily: 'Song'),
    caption:
        TextStyle(color: Colors.grey[500], fontSize: 23.0, fontFamily: 'Song'),
    display2:
        TextStyle(color: Colors.grey[500], fontSize: 16.0, fontFamily: 'Song'),
  ),
  accentColor: Colors.grey,
);

final ThemeData nightTheme = new ThemeData(
  primarySwatch: Colors.deepOrange,
  backgroundColor: Color.fromARGB(255, 99, 12, 95),
  appBarTheme: AppBarTheme(color: Colors.white),
  textTheme: TextTheme(
    title: TextStyle(color: Colors.black87, fontSize: 31.0, fontFamily: 'Song'),
    subtitle:
        TextStyle(color: Colors.black54, fontSize: 28.0, fontFamily: 'Song'),
    caption:
        TextStyle(color: Colors.grey[500], fontSize: 23.0, fontFamily: 'Song'),
    display2:
        TextStyle(color: Colors.grey[500], fontSize: 16.0, fontFamily: 'Song'),
  ),
  accentColor: Colors.grey,
);
