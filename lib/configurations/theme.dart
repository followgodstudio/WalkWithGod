import 'package:flutter/material.dart';

class MyColors {
  static const Color black = Colors.black87;
  static const Color lightBlue = Color.fromARGB(255, 50, 197, 255);
  static const Color pink = Color.fromARGB(255, 239, 71, 111);
  static const Color yellow = Color.fromARGB(255, 255, 235, 133);
  static const Color lightGreen = Color.fromARGB(255, 195, 255, 235);
  static const Color silver = Color.fromARGB(255, 240, 240, 240);
  static const Color lightGrey = Color.fromARGB(255, 224, 224, 224);
  static const Color grey = Color.fromARGB(255, 128, 128, 128);

  static const Color error = Colors.red;
  static const Color suceess = Color.fromARGB(255, 112, 193, 129);
}

final ThemeData dayTheme = new ThemeData(
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(color: Colors.white),
  buttonColor: MyColors.silver,
  textTheme: TextTheme(
    headline1:
        TextStyle(color: MyColors.black, fontSize: 30.0, fontFamily: 'Jinling'),
    headline2:
        TextStyle(color: MyColors.black, fontSize: 26.0, fontFamily: 'Jinling'),
    headline3:
        TextStyle(color: MyColors.black, fontSize: 22.0, fontFamily: 'Jinling'),
    headline4:
        TextStyle(color: MyColors.black, fontSize: 30.0, fontFamily: 'Lanting'),
    headline5:
        TextStyle(color: MyColors.black, fontSize: 26.0, fontFamily: 'Lanting'),
    headline6:
        TextStyle(color: MyColors.black, fontSize: 22.0, fontFamily: 'Lanting'),
    subtitle1: TextStyle(
        color: Colors.black54,
        fontSize: 21.5,
        fontFamily: 'Jinling',
        letterSpacing: 2,
        height: 2),
    bodyText1: TextStyle(
        color: Color.fromARGB(255, 77, 77, 77),
        fontSize: 16.0,
        fontFamily: 'LantingXianHei',
        letterSpacing: 1.4,
        height: 1.8),
    bodyText2: TextStyle(
      color: Color.fromARGB(255, 77, 77, 77),
      fontSize: 16.0,
      fontFamily: 'LantingXianHei',
      letterSpacing: -0.1,
    ),
    caption:
        TextStyle(color: Colors.grey[300], fontSize: 23.0, fontFamily: 'Song'),
    button:
        TextStyle(color: MyColors.black, fontSize: 29.0, fontFamily: 'Jinling'),
  ),
);

extension CustomStyles on TextTheme {
  TextStyle get headerSmall1 => const TextStyle(
        fontSize: 14.0,
        color: MyColors.black,
        fontFamily: 'FangzhengTeYaSong',
        letterSpacing: -0.1,
      );
  TextStyle get bodyTextBlack => const TextStyle(
        color: MyColors.black,
        fontSize: 16.0,
        fontFamily: 'LantingXianHei',
        letterSpacing: -0.1,
      );
  TextStyle get bodyTextWhite => const TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        fontFamily: 'Lanting',
        letterSpacing: -0.1,
      );
  TextStyle get captionMain => const TextStyle(
        fontSize: 14.0,
        color: MyColors.grey,
        fontFamily: 'LantingXianHei',
      );
  TextStyle get captionMainWideSpacing => const TextStyle(
      fontSize: 14.0,
      color: MyColors.grey,
      fontFamily: 'LantingXianHei',
      letterSpacing: 1.3);
  TextStyle get captionSmall => const TextStyle(
        fontSize: 10.0,
        color: MyColors.grey,
        fontFamily: 'LantingXianHei',
      );
  TextStyle get captionSmall2 => const TextStyle(
        fontSize: 12.0,
        color: MyColors.grey,
        fontFamily: 'LantingXianHei',
      );

  TextStyle get captionSmallBlack => const TextStyle(
        fontSize: 12.0,
        color: MyColors.black,
        fontFamily: 'Lanting',
      );
  TextStyle get captionSmallWhite => const TextStyle(
        fontSize: 14.0,
        color: Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'LantingXianHei',
      );
  TextStyle get captionMedium1 => const TextStyle(
        fontSize: 16.0,
        color: Color.fromARGB(255, 0, 0, 0),
        fontFamily: 'Lanting',
      );
  TextStyle get captionMediumWhite => const TextStyle(
        fontSize: 14.0,
        color: Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'Lanting',
      );
  TextStyle get captionMedium2 => const TextStyle(
        fontSize: 25.0,
        color: MyColors.black,
        fontFamily: 'FangzhengTeYaSong',
      );
  TextStyle get captionMedium3 => const TextStyle(
        fontSize: 14.0,
        color: Color.fromARGB(255, 194, 194, 194),
        fontFamily: 'LantingXianHei',
      );
  TextStyle get captionMedium4 => const TextStyle(
        fontSize: 14.0,
        color: Color.fromARGB(255, 77, 77, 77),
        fontFamily: 'LantingXianHei',
      );
  TextStyle get buttonMedium1 => const TextStyle(
        fontSize: 15.0,
        color: Color.fromARGB(255, 0, 0, 0),
        fontFamily: 'Lanting',
      );
  TextStyle get buttonMediumGray => const TextStyle(
        fontSize: 15.0,
        color: Color.fromARGB(255, 194, 194, 194),
        fontFamily: 'Lanting',
      );
  TextStyle get buttonLarge1 => const TextStyle(
        fontSize: 20.0,
        color: Color.fromARGB(255, 0, 0, 0),
        fontFamily: 'Lanting',
      );
  TextStyle get buttonLargeGray => const TextStyle(
        fontSize: 20.0,
        color: Color.fromARGB(255, 194, 194, 194),
        fontFamily: 'Lanting',
      );
}

final ThemeData nightTheme = new ThemeData();
