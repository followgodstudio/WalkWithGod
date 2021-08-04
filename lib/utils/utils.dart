import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_logs/flutter_logs.dart';

import '../exceptions/my_exception.dart';
import '../widgets/popup_dialog.dart';
import 'my_logger.dart';

Future<dynamic> exceptionHandling(
    BuildContext context, Future<dynamic> Function() function) async {
  try {
    return await function();
  } on MyException catch (error) {
    // Most exception should be translated to MyException
    MyLogger("Firestore").e(error.message);
    showPopUpDialog(context, false, error.message);
  } on FirebaseAuthException catch (error) {
    String message = error.message;
    String newMessage;
    MyLogger("Firebase").e(message);
    // print(error);
    // handle some general exceptions, such as network
    if (error.code == "network-request-failed") newMessage = "网络不佳";
    if (error.code == "wrong-password") newMessage = "邮箱或密码错误";
    showPopUpDialog(
        context, false, newMessage ?? "FirebaseException: " + message);
  } on PlatformException catch (error) {
    MyLogger("TODO-platform").e(error.message);
    showPopUpDialog(context, false, "PlatformException:" + error.message);
  } on Exception catch (error) {
    MyLogger("UnknownError").e(error.toString());
    FlutterLogs.exportLogs(exportType: ExportType.ALL);
  }
}

void showPopUpDialog(BuildContext context, bool isSuccess, String message,
    {int durationMilliseconds, Function afterDismiss, Function onPressed}) {
  if (durationMilliseconds == null)
    durationMilliseconds = isSuccess ? 1000 : 2000;
  Timer timer = Timer(Duration(milliseconds: durationMilliseconds), () {
    Navigator.of(context).pop(true);
  });
  Function _onPressed = (onPressed == null)
      ? null
      : () {
          Navigator.of(context).pop();
          onPressed();
          timer.cancel();
        };
  showDialog(
      context: context,
      barrierColor: Color.fromARGB(1, 255, 255, 255), // Near transparent
      builder: (context) {
        return PopUpDialog(isSuccess, message, onPressed: _onPressed);
      }).then((value) {
    timer.cancel();
    if (afterDismiss != null) afterDismiss();
  });
}

String getCreatedDuration(DateTime createdDate) {
  createdDate = createdDate ?? DateTime.now().toUtc();
  int timeDiffInMins = DateTime.now().toUtc().difference(createdDate).inMinutes;

  if (timeDiffInMins < 60) {
    return timeDiffInMins.toString() + "分钟前";
  }

  int timeDiffInHours = DateTime.now().toUtc().difference(createdDate).inHours;
  int timeDiffInDays = 0;
  int timeDiffInMonths = 0;
  int timeDiffInYears = 0;
  if (timeDiffInHours > 24 * 365) {
    timeDiffInYears = timeDiffInHours ~/ (24 * 365);
    //timeDiffInHours %= timeDiffInHours;
  } else if (timeDiffInHours > 24 * 30) {
    timeDiffInMonths = timeDiffInHours ~/ (24 * 30);
    //timeDiffInHours %= timeDiffInHours;
  } else if (timeDiffInHours > 24) {
    timeDiffInDays = timeDiffInHours ~/ 24;
    //timeDiffInHours %= timeDiffInHours;
  }

  return timeDiffInYears > 1
      ? timeDiffInYears.toString() + " 年前"
      : timeDiffInYears > 0
          ? timeDiffInYears.toString() + " 年前"
          : timeDiffInMonths > 1
              ? timeDiffInMonths.toString() + " 个月前"
              : timeDiffInMonths > 0
                  ? timeDiffInMonths.toString() + " 个月前"
                  : timeDiffInDays > 1
                      ? timeDiffInDays.toString() + " 天前"
                      : timeDiffInDays > 0
                          ? timeDiffInDays.toString() + " 天前"
                          : timeDiffInHours > 1
                              ? timeDiffInHours.toString() + " 小时前"
                              : timeDiffInHours > 0
                                  ? timeDiffInHours.toString() + " 小时前"
                                  : null;
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}
