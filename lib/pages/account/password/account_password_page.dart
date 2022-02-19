import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/pages/account/password/account_password_controller.dart';
import 'package:hikee/themes.dart';

class AccountPasswordPage extends GetView<AccountPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HikeeAppBar(title: Text('Update Password')),
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
                        label: 'Current Password',
                        hintText: 'Password currently using',
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextInput(
                        label: 'New Password',
                        hintText: 'New password for login',
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextInput(
                        label: 'Confirm New Password',
                        hintText: 'Confirm by typing again',
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    blurRadius: 16,
                    spreadRadius: -8,
                    color: Colors.black.withOpacity(.09),
                    offset: Offset(0, -6))
              ]),
              child: Button(
                minWidth: double.infinity,
                onPressed: () {},
                child: Text('Update'),
              ),
            )
          ],
        ));
  }
}
