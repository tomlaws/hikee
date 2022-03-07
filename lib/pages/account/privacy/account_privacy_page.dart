import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/pages/account/account_page.dart';
import 'package:hikees/pages/account/privacy/account_privacy_controller.dart';
import 'package:hikees/themes.dart';

class AccountPrivacyPage extends GetView<AccountPrivacyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(title: Text('privacyAndSecurity'.tr)),
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
            MutationBuilder(
                userOnly: true,
                mutation: () {
                  return controller.updatePrivacy();
                },
                builder: (mutate, loading) {
                  return Obx(
                    () => MenuListTile(
                      loading: loading || controller.user == null,
                      switchValue: controller.isPrivate.value,
                      onSwitchValueChanged: (v) {
                        controller.isPrivate.toggle();
                        mutate();
                      },
                      title: "hideTrailRecords".tr,
                    ),
                  );
                }),
            MenuListTile(
              onTap: () {
                Get.toNamed('/password');
              },
              title: "updatePassword".tr,
            ),
          ],
        ),
      )),
    );
  }
}
