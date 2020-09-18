import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';

String getCreatedDuration(DateTime createdDate) {
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

Future<bool> useWhiteTextColor(ImageProvider image) async {
  PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
    //CachedNetworkImageProvider(imageUrl),
    image,
    // Images are square
    size: Size(300, 300),

    // I want the dominant color of the top left section of the image
    region: Offset.zero & Size(40, 40),
  );

  Color dominantColor = paletteGenerator.dominantColor?.color;

  // Here's the problem
  // Sometimes dominantColor returns null
  // With black and white background colors in my tests
  if (dominantColor == null) print('Dominant Color null');

  return useWhiteForeground(dominantColor);
}

bool useWhiteForeground(Color backgroundColor) =>
    1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
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
