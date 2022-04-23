import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/error/error_response.dart';
import 'package:hikees/models/token.dart';
import 'package:hikees/providers/auth.dart';

class LoginController extends GetxController {
  AuthProvider _authProvider = Get.put(AuthProvider());
  TextInputController emailController = TextInputController();
  TextInputController passwordController = TextInputController();

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

  void onDone(token) {
    if (token != null) {
      Get.back();
    }
  }
}
