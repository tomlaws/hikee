import 'package:hikee/api.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/utils/http.dart';

class AuthService {
  Future<Token?> login(String email, String password) async {
    var res = await HttpUtils.post(
        API.getUri('/auth/login'), {'email': email, 'password': password});
    if (res['accessToken'] != null) {
      return Token.fromJson(res);
    } else {
      return null;
    }
  }

  Future<Token?> refreshAccessToken(Token token) async {
    var res = await HttpUtils.post(
        API.getUri('/auth/refresh'), {'refreshToken': token.refreshToken});
    if (res['accessToken'] != null) {
      return Token.fromJson(
          (token..updateAccessToken(res['accessToken'])).toJson());
    } else {
      return null;
    }
  }

  Future<Token?> register(String email, String password) async {
    var res = await HttpUtils.post(
        API.getUri('/auth/register'), {'email': email, 'password': password});
    if (res['accessToken'] != null) {
      return Token.fromJson(res);
    } else {
      return null;
    }
  }
}
