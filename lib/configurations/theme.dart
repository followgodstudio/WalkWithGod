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
        TextStyle(color: MyColors.black, fontSize: 26.0, fontFamily: 'Song'),
    headline2:
        TextStyle(color: MyColors.black, fontSize: 22.0, fontFamily: 'Song'),
    headline3:
        TextStyle(color: MyColors.black, fontSize: 16.0, fontFamily: 'Song'),
    headline4:
        TextStyle(color: MyColors.black, fontSize: 14.0, fontFamily: 'Song'),
    headline5: TextStyle(
      color: MyColors.black,
      fontSize: 22.0,
      fontFamily: 'Hei',
      fontWeight: FontWeight.w500,
    ),
    subtitle1: TextStyle(
        color: Colors.black54,
        fontSize: 21.5,
        fontFamily: 'Song',
        letterSpacing: 2,
        height: 2),
    bodyText1: TextStyle(
        color: Color.fromARGB(255, 77, 77, 77),
        fontSize: 16.0,
        fontFamily: 'Hei',
        fontWeight: FontWeight.w300,
        letterSpacing: 1.4,
        height: 1.8),
    bodyText2: TextStyle(
      color: Color.fromARGB(255, 77, 77, 77),
      fontSize: 16.0,
      fontFamily: 'Hei',
      fontWeight: FontWeight.w300,
      letterSpacing: -0.1,
    ),
    caption: TextStyle(
      fontSize: 14.0,
      color: MyColors.black,
      fontFamily: 'Hei',
      fontWeight: FontWeight.w300,
    ),
    button:
        TextStyle(color: MyColors.black, fontSize: 29.0, fontFamily: 'Song'),
  ),
);

extension CustomStyles on TextTheme {
  TextStyle get captionGrey => caption.copyWith(
        color: MyColors.grey,
      );
  TextStyle get captionSmall => const TextStyle(
        fontSize: 12.0,
        color: MyColors.grey,
        fontFamily: 'Hei',
        fontWeight: FontWeight.w300,
      );

  TextStyle get captionSmallBlack => const TextStyle(
        fontSize: 12.0,
        color: MyColors.black,
        fontFamily: 'Hei',
        fontWeight: FontWeight.w500,
      );
  TextStyle get captionMedium1 => const TextStyle(
        fontSize: 16.0,
        color: Color.fromARGB(255, 0, 0, 0),
        fontFamily: 'Hei',
        fontWeight: FontWeight.w500,
      );
  TextStyle get captionMedium3 => const TextStyle(
        fontSize: 14.0,
        color: Color.fromARGB(255, 194, 194, 194),
        fontFamily: 'Hei',
        fontWeight: FontWeight.w300,
      );
  TextStyle get captionMedium4 => const TextStyle(
        fontSize: 14.0,
        color: Color.fromARGB(255, 77, 77, 77),
        fontFamily: 'Hei',
        fontWeight: FontWeight.w300,
      );
  TextStyle get buttonMedium1 => const TextStyle(
        fontSize: 15.0,
        color: Color.fromARGB(255, 0, 0, 0),
        fontFamily: 'Hei',
        fontWeight: FontWeight.w500,
      );
  TextStyle get buttonMediumGray => const TextStyle(
        fontSize: 15.0,
        color: Color.fromARGB(255, 194, 194, 194),
        fontFamily: 'Hei',
        fontWeight: FontWeight.w500,
      );
  TextStyle get buttonLarge1 => const TextStyle(
        fontSize: 20.0,
        color: Color.fromARGB(255, 0, 0, 0),
        fontFamily: 'Hei',
        fontWeight: FontWeight.w500,
      );
  TextStyle get buttonLargeGray => const TextStyle(
        fontSize: 20.0,
        color: Color.fromARGB(255, 194, 194, 194),
        fontFamily: 'Hei',
        fontWeight: FontWeight.w500,
      );
}

final ThemeData nightTheme = new ThemeData();
