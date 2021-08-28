import 'package:flutter/foundation.dart';

class EnumUtil {
  static T fromString<T>(List<T> values, String enumString) {
    T e = values[0];
    values.forEach((item) {
      if (item.toString().split('.').last == enumString) {
        e = item;
      }
    });
    return e;
  }

  static String string(Object e) {
    return describeEnum(e);
  }
}
