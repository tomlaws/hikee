class TimeUtils {
  static String toText(int minutes) {
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
}