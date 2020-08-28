import 'package:flutter/material.dart';

final ThemeData dayTheme = new ThemeData(
  primarySwatch: Colors.deepOrange,
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(color: Colors.white),
  accentColor: Color.fromARGB(255, 0, 169, 157),
  textTheme: TextTheme(
    headline1:
        TextStyle(color: Colors.black87, fontSize: 30.0, fontFamily: 'Jinling'),
    headline2:
        TextStyle(color: Colors.black87, fontSize: 26.0, fontFamily: 'Jinling'),
    headline3:
        TextStyle(color: Colors.black87, fontSize: 22.0, fontFamily: 'Jinling'),
    headline4:
        TextStyle(color: Colors.black87, fontSize: 30.0, fontFamily: 'Lanting'),
    headline5:
        TextStyle(color: Colors.black87, fontSize: 26.0, fontFamily: 'Lanting'),
    headline6:
        TextStyle(color: Colors.black87, fontSize: 22.0, fontFamily: 'Lanting'),
    subtitle1: TextStyle(
        color: Colors.black54,
        fontSize: 21.5,
        fontFamily: 'Jinling',
        letterSpacing: 2,
        height: 2),
    subtitle2: TextStyle(
        color: Color.fromARGB(255, 0, 169, 157),
        fontSize: 16.0,
        fontFamily: 'Song'),
    bodyText1: TextStyle(
        color: Color.fromARGB(255, 77, 77, 77),
        fontSize: 16.0,
        fontFamily: 'Jinling',
        letterSpacing: 1.4,
        height: 1.8),
    bodyText2: TextStyle(
      color: Color.fromARGB(255, 77, 77, 77),
      fontSize: 14.0,
      fontFamily: 'Lanting',
      letterSpacing: -0.1,
    ),
    caption:
        TextStyle(color: Colors.grey[300], fontSize: 23.0, fontFamily: 'Song'),
    overline: TextStyle(
      decoration: TextDecoration.overline,
      color: Color.fromARGB(255, 128, 128, 128),
      fontSize: 10.0,
      fontFamily: 'Lanting',
      letterSpacing: -0.1,
    ),
    button:
        TextStyle(color: Colors.black87, fontSize: 29.0, fontFamily: 'Jinling'),
  ),
);

extension CustomStyles on TextTheme {
  TextStyle get error => const TextStyle(
      fontSize: 15.0, color: Colors.red, fontWeight: FontWeight.bold);
  TextStyle get headerSmall1 => const TextStyle(
        fontSize: 14.0,
        color: Colors.black,
        fontFamily: 'FangzhengTeYaSong',
        letterSpacing: -0.1,
      );
  TextStyle get bodyText3 => const TextStyle(
        fontSize: 10.0,
        color: Colors.blue,
        fontFamily: 'Lanting',
        letterSpacing: -0.1,
      );
  TextStyle get captionMain => const TextStyle(
        fontSize: 16.0,
        color: Color.fromARGB(255, 128, 128, 128),
        fontFamily: 'Avenir',
      );
  TextStyle get captionSmall1 => const TextStyle(
        fontSize: 10.0,
        color: Color.fromARGB(255, 0, 169, 157),
        fontFamily: 'Lanting',
      );
  TextStyle get captionSmall2 => const TextStyle(
        fontSize: 10.0,
        color: Color.fromARGB(255, 128, 128, 128),
        fontFamily: 'LantingHeiXianHei',
      );
  TextStyle get captionSmallWhite => const TextStyle(
        fontSize: 10.0,
        color: Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'Lanting',
      );
  TextStyle get captionMedium1 => const TextStyle(
        fontSize: 14.0,
        color: Color.fromARGB(255, 0, 169, 157),
        fontFamily: 'Lanting',
      );
  TextStyle get captionMediumWhite => const TextStyle(
        fontSize: 14.0,
        color: Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'Lanting',
      );
  TextStyle get captionMedium2 => const TextStyle(
        fontSize: 25.0,
        //color: Color.fromARGB(255, 0, 169, 157),
        color: Colors.black,
        fontFamily: 'FangzhengTeYaSong',
      );
  TextStyle get captionLarge1 => const TextStyle(
        fontSize: 18.0,
        color: Color.fromARGB(255, 0, 169, 157),
        fontFamily: 'Lanting',
      );
  TextStyle get buttonSmall1 => const TextStyle(
        fontSize: 10.0,
        color: Color.fromARGB(255, 0, 0, 0),
        fontFamily: 'Lanting',
      );
  TextStyle get buttonMedium1 => const TextStyle(
        fontSize: 15.0,
        color: Color.fromARGB(255, 0, 0, 0),
        fontFamily: 'Lanting',
      );
  TextStyle get buttonLarge1 => const TextStyle(
        fontSize: 20.0,
        color: Color.fromARGB(255, 0, 0, 0),
        fontFamily: 'Lanting',
      );
}

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
