import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hikees/manager/token.dart';
import 'package:hikees/models/error/error_response.dart';
import 'package:hikees/models/token.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class BaseProvider extends GetConnect {
  static TokenManager _tokenManager = TokenManager();

  String getUrl() {
    var endpoint = FlavorConfig.instance.variables["API_ENDPOINT"] ??
        "https://api.hikees.com/";
    return endpoint;
  }

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = getUrl();
    httpClient.addRequestModifier<void>((request) async {
      request.headers['connection'] = 'keep-alive';
      if (kIsWeb) {
        request.headers.remove('user-agent');
        request.headers.remove('content-length');
        request.headers['Access-Control-Allow-Origin'] = '*';
      }
      if (request.url.path.contains('/auth')) return request;
      if (_tokenManager.token != null) {
        if (_tokenManager.nearlyExpire) {
          print('Token expired. Trying to refresh.');
          await _refreshToken();
        }
        request.headers["Authorization"] =
            "Bearer ${_tokenManager.token!.accessToken}";
      }
      return request;
    });
    httpClient.addResponseModifier((request, response) {
      if (![200, 201].contains(response.statusCode)) {
        print(response.body);
        throw ErrorResponse.fromJson(response.body as Map<String, dynamic>);
      }
      print(response.body);
      return response;
    });
  }

  Future<void> _refreshToken() async {
    Duration remainingTime =
        JwtDecoder.getRemainingTime(_tokenManager.token!.refreshToken);
    if (remainingTime < Duration(minutes: 1)) {
      //refresh
      print('Refresh token expired. Logout now');
      _tokenManager.token = null;
      throw new Exception('Refresh token expired');
      //return;
    }
    var res = await post(
        'auth/refresh', {'refreshToken': _tokenManager.token!.refreshToken});
    Token updatedToken = Token.fromJson((_tokenManager.token!
          ..updateAccessToken(res.body['accessToken']))
        .toJson());
    _tokenManager.token = updatedToken;
  }
}
