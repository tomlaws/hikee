import 'package:get/get.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/providers/auth.dart';

class AuthController extends GetxController {
  final _authProvider = Get.put(AuthProvider());
  RxBool get loggedIn => _authProvider.loggedIn;
  final me = Rxn<User?>();

  @override
  void onInit() {
    super.onInit();
    if (loggedIn.value) {
      _updateMe();
    }
    loggedIn.listen((loggedIn) async {
      if (loggedIn) {
        _updateMe();
      } else {
        me.value = null;
      }
    });
  }

  Future<void> _updateMe() async {
    me.value = await _authProvider.getMe();
  }

  Future<Token?> signIn(String email, String password) {
    return _authProvider.login(email, password);
  }
}
