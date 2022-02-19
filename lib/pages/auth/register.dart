import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/button.dart';
import 'package:hikee/components/core/mutation_builder.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/pages/auth/register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
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
                  height: 16,
                ),
                TextInput(
                  hintText: 'Confirm password',
                  obscureText: true,
                  controller: controller.confirmPasswordController,
                ),
                Container(
                  height: 32,
                ),
                SizedBox(
                  width: 200,
                  child: MutationBuilder<Token?>(
                    mutation: controller.register,
                    onError: controller.onError,
                    onDone: controller.onDone,
                    builder: (mutate, loading) {
                      return Button(
                          child: Text('REGISTER'),
                          loading: loading,
                          onPressed: mutate);
                    },
                  ),
                ),
                Container(
                  height: 16,
                ),
                GestureDetector(
                  child: Text('Or sign in now'),
                  onTap: () {
                    Get.offNamed('/login');
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
