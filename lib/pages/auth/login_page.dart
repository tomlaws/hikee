import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/token.dart';
import 'package:hikees/pages/auth/login_controller.dart';

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
            child: Text(
              'Hikees',
              style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.primaryColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextInput(
                  hintText: 'email'.tr,
                  controller: controller.emailController,
                ),
                Container(
                  height: 16,
                ),
                TextInput(
                  hintText: 'password'.tr,
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
                    onDone: controller.onDone,
                    errorMapping: {
                      'email': controller.emailController,
                      'password': controller.passwordController
                    },
                    builder: (mutate, loading) {
                      return Button(
                          child: Text('login'.tr),
                          loading: loading,
                          onPressed: mutate);
                    },
                  ),
                ),
                Container(
                  height: 16,
                ),
                GestureDetector(
                  child: Text('orSignUpNow'.tr),
                  onTap: () {
                    Get.offNamed('/register');
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
