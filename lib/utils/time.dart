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
    return (minutes > 0 ? formatMinutes(minutes) : '') + (remainder != 0 && hour < 1 ? ' ${remainder}s' : '');
  }
}
