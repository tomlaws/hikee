import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/bottom_bar.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/pages/account/password/account_password_controller.dart';
import 'package:hikees/themes.dart';

class AccountPasswordPage extends GetView<AccountPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HikeeAppBar(title: Text('updatePassword'.tr)),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextInput(
                        label: 'currentPassword'.tr,
                        hintText: 'password'.tr,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextInput(
                        label: 'newPassword'.tr,
                        hintText: 'password'.tr,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextInput(
                        label: 'confirmNewPassword'.tr,
                        hintText: 'password'.tr,
                      )
                    ],
                  ),
                ),
              ),
            ),
            BottomBar(
              child: Button(
                minWidth: double.infinity,
                onPressed: () {},
                child: Text('update'.tr),
              ),
            )
          ],
        ));
  }
}