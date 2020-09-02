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
