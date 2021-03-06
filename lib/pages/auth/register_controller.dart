import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/error/error_response.dart';
import 'package:hikees/models/token.dart';
import 'package:hikees/providers/auth.dart';

class RegisterController extends GetxController {
  AuthProvider _authProvider = Get.put(AuthProvider());
  TextInputController emailController = TextInputController(text: '');
  TextInputController passwordController = TextInputController(text: '');
  TextInputController confirmPasswordController = TextInputController(text: '');

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<Token?> register() {
    emailController.clearError();
    passwordController.clearError();
    confirmPasswordController.clearError();

    if (passwordController.text != confirmPasswordController.text) {
      throw confirmPasswordController.error = 'passwordsDoNotMatch'.tr;
    }
    var email = emailController.text;
    var password = passwordController.text;
    return _authProvider.register(email, password);
  }

  void onDone(token) {
    if (token != null) {
      Get.back();
    }
  }
}
