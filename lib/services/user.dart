import 'package:hikee/constants.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/utils/http.dart';

class UserService {
  Future<User?> getMe(Token token) async {
    final uri = Uri.https(API_HOST, '/users/me');
    var res = await HttpUtils.get(uri, accessToken: token.accessToken);
    try {
      return User.fromJson(res);
    } catch (ex) {
      return null;
    }
  }
}
