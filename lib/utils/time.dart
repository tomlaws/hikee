import 'package:intl/intl.dart';

class TimeUtils {
  static String formatMinutes(int minutes) {
    int remainder = minutes % 60;
    int hour = (minutes / 60).floor();
    if (hour > 0) {
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
        (minutes < 1 || (remainder != 0 && hour < 1) ? ' ${remainder}s' : '');
  }

  static String timeAgoSinceDate(DateTime dateTime,
      {bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(dateTime);
    print(dateTime.toLocal());

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
