import 'package:get/get.dart';
import 'package:hikee/manager/token.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/providers/shared/base.dart';

class AuthProvider extends BaseProvider {
  static TokenManager _tokenManager = TokenManager();
  var loggedIn = false.obs;
  final me = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    loggedIn.value = _tokenManager.token != null;
    _tokenManager.onTokenChange((t) {
      loggedIn.value = t != null;
      if (t != null) {
        _getMe();
      }
    });
  }

  Future<Token?> login(String email, String password) async {
    var res = await post('auth/login', {'email': email, 'password': password});
    return _tokenManager.token = Token.fromJson(res.body);
  }

  Future<User> _getMe() async {
    me.value = null;
    int? userId = _tokenManager.userId;
    if (userId == null) {
      throw new Error();
    }
    var res = await get('users/${userId.toString()}');
    return me.value = User.fromJson(res.body);
  }

  Future<void> refreshMe() async {
    await _getMe();
  }

  Future<Token?> register(String email, String password) async {
    var res =
        await post('auth/register', {'email': email, 'password': password});
    return _tokenManager.token = Token.fromJson(res.body);
  }

  void logout() {
    _tokenManager.token = null;
    me.value = null;
  }
}
