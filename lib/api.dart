import 'package:hikee/constants.dart';

class API {
  static bool dev = true;
  static getUri(String path) {
    if (dev) {
      return Uri.http(API_HOST_DEV, path);
    } else {
      return Uri.https(API_HOST, path);
    }
  }
}