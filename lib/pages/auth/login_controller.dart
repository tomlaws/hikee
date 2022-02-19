import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/error/error_response.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/providers/auth.dart';

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

  void onError(ErrorResponse error) {
    emailController.error = error.getFieldError('email');
    passwordController.error = error.getFieldError('password');
    if (error.statusCode == 401)
      passwordController.error = 'Incorrect password';
  }

  void onDone(token) {
    if (token != null) {
      Get.back();
    }
  }
}
