import 'package:get/get.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/providers/user.dart';

class AccountPasswordController extends GetxController {
  TextInputController passwordController = TextInputController();
  TextInputController confirmPasswordController = TextInputController();
  final _userProvider = Get.find<UserProvider>();

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> updatePassword() async {
    return await _userProvider.updatePassword(passwordController.text);
  }
}
