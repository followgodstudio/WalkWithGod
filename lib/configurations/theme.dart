import 'package:flutter/material.dart';

class MyColors {
  static const Color black = Colors.black87;
  static const Color deepBlue = Color.fromARGB(255, 0, 77, 106);
  static const Color lightBlue = Color.fromARGB(255, 50, 197, 255);
  static const Color pink = Color.fromARGB(255, 239, 71, 111);
  static const Color yellow = Color.fromARGB(255, 247, 181, 0);
  static const Color lightGreen = Color.fromARGB(255, 195, 255, 235);
  static const Color silver = Color.fromARGB(255, 240, 240, 240);
  static const Color lightGrey = Color.fromARGB(255, 224, 224, 224);
  static const Color midGrey = Color.fromARGB(255, 194, 194, 194);
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
    headline4: TextStyle(
        color: MyColors.black,
        fontSize: 22.0,
        fontFamily: 'Hei',
        fontWeight: FontWeight.w700),
    headline5: TextStyle(
      color: MyColors.black,
      fontSize: 22.0,
      fontFamily: 'Hei',
      fontWeight: FontWeight.w500,
    ),
    subtitle1: TextStyle(
        color: MyColors.black,
        fontSize: 21.5,
        fontFamily: 'Song',
        letterSpacing: 2,
        height: 2),
    bodyText1: TextStyle(
        color: MyColors.black,
        fontSize: 16.0,
        fontFamily: 'Hei',
        fontWeight: FontWeight.w300,
        letterSpacing: 1.4,
        height: 1.8),
    caption: TextStyle(
      fontSize: 14.0,
      color: MyColors.black,
      fontFamily: 'Hei',
      fontWeight: FontWeight.w300,
    ),
    button: TextStyle(
      fontSize: 12.0,
      color: MyColors.black,
      fontFamily: 'Hei',
      fontWeight: FontWeight.w500,
    ),
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
  TextStyle get captionMedium1 => const TextStyle(
        fontSize: 16.0,
        color: MyColors.black,
        fontFamily: 'Hei',
        fontWeight: FontWeight.w500,
      );
  TextStyle get captionMedium2 => const TextStyle(
        fontSize: 14.0,
        color: MyColors.grey,
        fontFamily: 'Hei',
        fontWeight: FontWeight.w300,
      );
  TextStyle get buttonLarge => const TextStyle(
        fontSize: 20.0,
        color: MyColors.black,
        fontFamily: 'Hei',
        fontWeight: FontWeight.w500,
      );
  TextStyle get dateSmall => const TextStyle(
        fontSize: 16.0,
        color: MyColors.grey,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.w200,
        height: 1.5,
      );
  TextStyle get dateLarge => const TextStyle(
        fontSize: 60.0,
        color: MyColors.yellow,
        fontFamily: 'Rajdhani',
        fontWeight: FontWeight.w700,
      );
  TextStyle get curDaySmall => const TextStyle(
        color: MyColors.black,
        fontSize: 20.0,
        fontFamily: 'Hei',
        fontWeight: FontWeight.w500,
        height: 1.2,
      );
}

final ThemeData nightTheme = new ThemeData();
