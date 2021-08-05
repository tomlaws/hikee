import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/models/auth.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/services/user.dart';

class Me extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  UserService _userService = GetIt.I<UserService>();

  Me(Auth? auth) {
    if (auth == null) return;
    auth.getToken().then((token) {
      if (token != null) {
        _userService.getMe(token).then((user) {
          _user = user;
        }).catchError((err) {
          print(err);
        });
      } else {
        _user = null;
      }
    }).catchError((err) {
      print(err);
    });
  }
}
