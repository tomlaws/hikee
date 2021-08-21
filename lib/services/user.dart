import 'dart:io';

import 'package:hikee/api.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/utils/http.dart';

class UserService {
  Future<User?> getMe(Token token) async {
    var res = await HttpUtils.get(API.getUri('/users/me'),
        accessToken: token.accessToken);
    try {
      return User.fromJson(res);
    } catch (ex) {
      return null;
    }
  }

  Future<bool?> changePassword(Token token, {required String password}) async {
    var res = await HttpUtils.patch(
        API.getUri('/users/password'), {'password': password},
        accessToken: token.accessToken);
    return true;
  }

  Future<User?> changeNickname(Token token, {required String nickname}) async {
    var res = await HttpUtils.patch(
        API.getUri('/users/nickname'), {'nickname': nickname},
        accessToken: token.accessToken);
    return User.fromJson(res);
  }

  Future<User?> changeIcon(Token token, {required File file}) async {
    var res = await HttpUtils.patchUpload(API.getUri('/users/icon'),
        file: file, accessToken: token.accessToken);
    return User.fromJson(res);
  }
}
