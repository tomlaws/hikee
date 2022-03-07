import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/pages/account/account_page.dart';
import 'package:hikees/pages/account/profile/account_profile_controller.dart';
import 'package:hikees/themes.dart';

class AccountProfilePage extends GetView<AccountProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(title: Text('profile'.tr)),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(16),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            boxShadow: [Themes.lightShadow],
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          children: [
            MenuListTile(
              onTap: () {
                controller.updateNickname();
              },
              title: "updateNickname".tr,
            ),
          ],
        ),
      )),
    );
  }
}
