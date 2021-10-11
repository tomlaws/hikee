import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/pages/auth/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextInput(
                  hintText: 'Email',
                  controller: controller.emailController,
                ),
                Container(
                  height: 16,
                ),
                TextInput(
                  hintText: 'Password',
                  obscureText: true,
                  controller: controller.passwordController,
                ),
                Container(
                  height: 32,
                ),
                SizedBox(
                  width: 200,
                  child: MutationBuilder<Token?>(
                    mutation: () {
                      return controller.signIn();
                    },
                    onDone: (token) {
                      if (token != null) {
                        Get.back();
                      }
                    },
                    onError: (error) {
                      controller.emailController.error =
                          error.getFieldError('email');
                      controller.passwordController.error =
                          error.getFieldError('password');
                      if (error.statusCode == 401)
                        controller.passwordController.error =
                            'Incorrect password';
                    },
                    builder: (mutate, loading) {
                      return Button(
                          child: Text('LOGIN'),
                          loading: loading,
                          onPressed: mutate);
                    },
                  ),
                ),
                Container(
                  height: 16,
                ),
                GestureDetector(
                  child: Text('Or sign up now'),
                  onTap: () {
                    Get.replace('/register');
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
