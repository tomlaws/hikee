import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/bottom_bar.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/pages/account/password/account_password_controller.dart';

class AccountPasswordPage extends GetView<AccountPasswordController> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HikeeAppBar(title: Text('updatePassword'.tr)),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextInput(
                          label: 'newPassword'.tr,
                          hintText: 'password'.tr,
                          controller: controller.passwordController,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextInput(
                          label: 'confirmNewPassword'.tr,
                          hintText: 'password'.tr,
                          controller: controller.confirmPasswordController,
                          validator: (v) {
                            if (v != controller.passwordController.text) {
                              return 'passwordsDoNotMatch'.tr;
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              BottomBar(
                child: MutationBuilder(
                  builder: (mutate, loading) => Button(
                    loading: loading,
                    minWidth: double.infinity,
                    onPressed: mutate,
                    child: Text('update'.tr),
                  ),
                  mutation: () async {
                    if (_formKey.currentState?.validate() == true)
                      return await controller.updatePassword();
                    else
                      throw new Error();
                  },
                  onDone: (res) {
                    Get.back();
                  },
                  errorMapping: {'password': controller.passwordController},
                ),
              )
            ],
          ),
        ));
  }
}
