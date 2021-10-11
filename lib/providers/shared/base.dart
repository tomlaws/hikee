import 'package:get/get.dart';
import 'package:hikee/manager/token.dart';
import 'package:hikee/models/error/error_response.dart';
import 'package:hikee/models/token.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class BaseProvider extends GetConnect {
  static TokenManager _tokenManager = TokenManager();

  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'http://127.0.0.1:3000/';
    httpClient.addRequestModifier<void>((request) async {
      //print(request.url.path);
      if (request.url.path.contains('/auth')) return request;
      if (_tokenManager.token != null) {
        var accessToken = _tokenManager.token!.accessToken;
        Duration remainingTime = JwtDecoder.getRemainingTime(accessToken);
        if (remainingTime < Duration(minutes: 1)) {
          //refresh
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
    print(res.body);
    Token updatedToken = Token.fromJson((_tokenManager.token!
          ..updateAccessToken(res.body['accessToken']))
        .toJson());
    _tokenManager.token = updatedToken;
  }
}
