import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpUtils {
  static get(Uri uri, {String? accessToken}) async {
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.get(uri, headers: headers);
    return jsonDecode(res.body);
  }

  static post(Uri uri, Map<String, dynamic> data) async {
    final res = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }
}
