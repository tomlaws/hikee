import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/mutation_builder.dart';
import 'package:hikee/pages/account/account_page.dart';
import 'package:hikee/pages/account/privacy/account_privacy_controller.dart';
import 'package:hikee/themes.dart';

class AccountPrivacyPage extends GetView<AccountPrivacyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(title: Text('Privacy & Security')),
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
            FutureBuilder(
                future: controller.getMe,
                builder: ((context, snapshot) {
                  return MutationBuilder(
                      userOnly: true,
                      mutation: () {
                        return controller.updatePrivacy();
                      },
                      builder: (mutate, loading) {
                        return Obx(
                          () => MenuListTile(
                            loading: snapshot.data == null || loading,
                            switchValue: controller.isPrivate.value,
                            onSwitchValueChanged: (v) {
                              controller.isPrivate.toggle();
                              mutate();
                            },
                            title: "Hide Trail Records",
                          ),
                        );
                      });
                })),
            MenuListTile(
              onTap: () {
                Get.toNamed('/password');
              },
              title: "Update Password",
            ),
          ],
        ),
      )),
    );
  }
}
