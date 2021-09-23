import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/old_providers/auth.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/services/user.dart';

class MeProvider extends ChangeNotifier {
  AuthProvider _authProvider;
  User? _user;
  User? get user => _user;
  UserService _userService = GetIt.I<UserService>();

  MeProvider({required AuthProvider authProvider})
      : _authProvider = authProvider {
    _authProvider.getToken().then((token) {
      if (token != null) {
        _userService.getMe(token).then((user) {
          _user = user;
          notifyListeners();
        }).catchError((err) {
          print(err);
        });
      } else {
        _user = null;
        notifyListeners();
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> changeNickname(String nickname) async {
    User? result = await _userService
        .changeNickname((await _authProvider.getToken())!, nickname: nickname);
    if (result != null) {
      _user = result;
      notifyListeners();
    }
  }

  Future<void> changeIcon(File file) async {
    User? result = await _userService
        .changeIcon((await _authProvider.getToken())!, file: file);
    if (result != null) {
      _user = result;
      notifyListeners();
    }
  }
}
