import 'dart:convert';
import 'dart:io';
import 'package:hikee/models/error/error_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HttpUtils {
  static get(Uri uri, {String? accessToken}) async {
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.get(uri, headers: headers);
    if (![200, 201].contains(res.statusCode)) {
      throw ErrorResponse.fromJson(jsonDecode(res.body));
    }
    return jsonDecode(res.body);
  }

  static post(Uri uri, Map<String, dynamic> data, {String? accessToken}) async {
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    if (![200, 201].contains(res.statusCode)) {
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
    if (![200, 201].contains(res.statusCode)) {
      throw ErrorResponse.fromJson(jsonDecode(res.body));
    }
    return jsonDecode(res.body);
  }

  static delete(Uri uri, {String? accessToken}) async {
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    final res = await http.delete(uri, headers: headers);
    if (![200, 201].contains(res.statusCode)) {
      throw ErrorResponse.fromJson(jsonDecode(res.body));
    }
    return jsonDecode(res.body);
  }

  static patchUpload(Uri uri, {required File file, String? accessToken}) async {
    final request = http.MultipartRequest('PATCH', uri);
    if (accessToken != null) {
      request.headers["Content-Type"] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $accessToken';
    }
    var bytes = await file.readAsBytes();
    request.files.add(new http.MultipartFile.fromBytes('file', bytes,
        filename: "icon.${file.path.split(".").last}",
        contentType: MediaType("image", "${file.path.split(".").last}")));
    http.Response res = await http.Response.fromStream(await request.send());
    if (![200, 201].contains(res.statusCode)) {
      throw ErrorResponse.fromJson(jsonDecode(res.body));
    }
    return jsonDecode(res.body);
  }
}
