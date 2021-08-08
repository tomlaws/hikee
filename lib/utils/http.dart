import 'dart:convert';

import 'package:hikee/models/error/error_response.dart';
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
    if (![200,201].contains(res.statusCode)) {
      throw ErrorResponse.fromJson(jsonDecode(res.body));
    }
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
    if (![200,201].contains(res.statusCode)) {
      throw ErrorResponse.fromJson(jsonDecode(res.body));
    }
    return jsonDecode(res.body);
  }

  static patch(Uri uri, Map<String, dynamic> data,
      {String? accessToken}) async {
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.patch(uri, headers: headers, body: jsonEncode(data));
    if (![200,201].contains(res.statusCode)) {
      throw ErrorResponse.fromJson(jsonDecode(res.body));
    }
    return jsonDecode(res.body);
  }
}
