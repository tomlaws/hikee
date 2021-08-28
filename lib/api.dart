import 'package:hikee/constants.dart';

class API {
  static bool dev = true;
  static getUri(String path, {Map<String, dynamic>? queryParams}) {
    if (dev) {
      print(Uri.http(API_HOST_DEV, path, queryParams).toString());
      return Uri.http(API_HOST_DEV, path, queryParams);
    } else {
      print(Uri.https(API_HOST, path, queryParams).toString());
      return Uri.https(API_HOST, path, queryParams);
    }
  }
}
