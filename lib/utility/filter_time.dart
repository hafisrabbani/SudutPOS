import 'package:sudut_pos/type/timeType.dart';

class FilterTimeUtils {
  static DateTime getStartDate(filterTimeType filterTime) {
    DateTime now = DateTime.now();
    switch (filterTime) {
      case filterTimeType.WEEKLY:
        return now.subtract(Duration(days: now.weekday - 1));
      case filterTimeType.MONTHLY:
        return DateTime(now.year, now.month, 1);
      case filterTimeType.YEARLY:
        return DateTime(now.year, 1, 1);
      case filterTimeType.ALL:
      default:
        return DateTime(1970, 1, 1); // Dummy start date for all time
    }
  }

  static DateTime getEndDate(filterTimeType filterTime) {
    DateTime now = DateTime.now();
    switch (filterTime) {
      case filterTimeType.WEEKLY:
        return now.subtract(Duration(days: now.weekday - 1)).add(Duration(days: 7));
      case filterTimeType.MONTHLY:
        return DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));
      case filterTimeType.YEARLY:
        return DateTime(now.year + 1, 1, 1).subtract(Duration(days: 1));
      case filterTimeType.ALL:
      default:
        return now;
    }
  }
}