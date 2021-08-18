import 'package:hikee/constants.dart';

class API {
  static bool dev = true;
  static getUri(String path, {Map<String, dynamic>? queryParams}) {
    if (dev) {
      return Uri.http(API_HOST_DEV, path, queryParams);
    } else {
      return Uri.https(API_HOST, path, queryParams);
    }
  }
}
