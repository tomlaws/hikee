import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/models/preferences.dart';
import 'package:hikees/pages/account/account_page.dart';
import 'package:hikees/pages/account/privacy/account_privacy_controller.dart';
import 'package:hikees/providers/preferences.dart';
import 'package:hikees/themes.dart';
import 'package:hikees/utils/dialog.dart';

class AccountPreferencesPage extends GetView<AccountPrivacyController> {
  final _preferencesProvider = Get.find<PreferencesProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(title: Text('preferences'.tr)),
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
                DialogUtils.showDialog(
                    'mapProvider'.tr,
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...MapProvider.values
                                .map((mapProvider) => Button(
                                      onPressed: () {
                                        _preferencesProvider.preferences
                                            .update((val) {
                                          val?.mapProvider = mapProvider;
                                        });
                                        Get.back();
                                      },
                                      child: Text(mapProvider.readableString,
                                          style: TextStyle(
                                              color: _preferencesProvider
                                                          .preferences
                                                          .value
                                                          ?.mapProvider ==
                                                      mapProvider
                                                  ? Colors.black
                                                  : Colors.black54)),
                                      invert: true,
                                    ))
                                .toList(),
                          ],
                        )));
              },
              title: "mapProvider".tr,
              trailing: Obx(() {
                var mapProvider =
                    _preferencesProvider.preferences.value!.mapProvider;
                return Text(mapProvider.readableString);
              }),
            ),
            MenuListTile(
              onTap: () {
                DialogUtils.showDialog(
                    'language'.tr,
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...Language.values
                                .map((lang) => Button(
                                      onPressed: () {
                                        _preferencesProvider.preferences
                                            .update((val) {
                                          val?.language = lang;
                                        });
                                        Get.back();
                                      },
                                      child: Text(lang.readableString,
                                          style: TextStyle(
                                              color: _preferencesProvider
                                                          .preferences
                                                          .value
                                                          ?.language ==
                                                      lang
                                                  ? Colors.black
                                                  : Colors.black54)),
                                      invert: true,
                                    ))
                                .toList(),
                          ],
                        )));
              },
              title: "language".tr,
              trailing: Obx(() {
                var language = _preferencesProvider.preferences.value!.language;
                return Text(language.readableString);
              }),
            ),
          ],
        ),
      )),
    );
  }
}
