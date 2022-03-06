import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimeUtils {
  static String formatMinutes(int minutes, {bool hourOnly = false}) {
    int remainder = minutes % 60;
    int hour = (minutes / 60).floor();
    if (hour > 0 || hourOnly) {
      if (remainder == 0) {
        return '${hour}h';
      }
      return '${hour}h ${remainder}m';
    } else {
      return '${remainder}m';
    }
  }

  static String formatSeconds(int seconds) {
    int remainder = seconds % 60;
    int minutes = (seconds / 60).floor();
    int hour = (minutes / 60).floor();
    return (minutes > 0 ? formatMinutes(minutes) : '') +
        (minutes < 1 || (remainder != 0 && hour < 1) ? '${remainder}s' : '');
  }

  static String timeAgoSinceDate(DateTime dateTime,
      {bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(dateTime);

    // if ((difference.inDays / 7).floor() <= 1) {
    //   return (numericDates) ? '1 week ago' : 'Last week';
    // } else
    if (difference.inDays >= 2) {
      return '${difference.inDays} ' + 'daysAgo'.tr;
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 ' + 'daysAgo'.tr : 'yesterday'.tr;
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} ' + 'hoursAgo'.tr;
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 ' + 'hourAgo'.tr : 'An ' + 'hourAgo'.tr;
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} ' + 'minutesAgo'.tr;
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 ' + 'minuteAgo'.tr : 'A ' + 'minuteAgo'.tr;
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} ' + 'secondsAgo'.tr;
    } else {
      return 'justNow'.tr;
    }
  }
}
