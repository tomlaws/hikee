import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/providers/auth.dart';

class LoginController extends GetxController {
  TextInputController emailController = TextInputController();
  TextInputController passwordController = TextInputController();
  AuthProvider _authProvider = Get.put(AuthProvider());

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<Token?> signIn() {
    emailController.clearError();
    passwordController.clearError();
    var email = emailController.text;
    var password = passwordController.text;
    return _authProvider.login(email, password);
  }
}
