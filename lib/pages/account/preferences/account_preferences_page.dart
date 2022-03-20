import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/models/preferences.dart';
import 'package:hikees/pages/account/account_page.dart';
import 'package:hikees/pages/account/preferences/account_preferences_controller.dart';
import 'package:hikees/themes.dart';
import 'package:hikees/utils/dialog.dart';

class AccountPreferencesPage extends GetView<AccountPreferencesController> {
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
                                        controller
                                            .preferencesProvider.preferences
                                            .update((val) {
                                          val?.mapProvider = mapProvider;
                                        });
                                        Get.back();
                                      },
                                      child: Text(mapProvider.readableString,
                                          style: TextStyle(
                                              color: controller
                                                          .preferencesProvider
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
                var mapProvider = controller
                    .preferencesProvider.preferences.value!.mapProvider;
                return Text(mapProvider.readableString);
              }),
            ),
            MenuListTile(
              onTap: () {
                DialogUtils.showDialog(
                    'offlineMapProvider'.tr,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...[null, ...MapProvider.values]
                            .map((mapProvider) => Button(
                                  onPressed: () {
                                    controller
                                        .updateOfflineMapProvider(mapProvider);
                                  },
                                  child: Obx(() {
                                    // dont remove these two lines
                                    return Text(
                                        mapProvider == null
                                            ? 'none'.tr
                                            : mapProvider.readableString,
                                        style: TextStyle(
                                            color: controller
                                                        .preferencesProvider
                                                        .preferences
                                                        .value
                                                        ?.offlineMapProvider ==
                                                    mapProvider
                                                ? Colors.black
                                                : Colors.black54));
                                  }),
                                  invert: true,
                                ))
                            .toList(),
                      ],
                    ));
              },
              title: "offlineMapProvider".tr,
              trailing: Obx(() {
                var mapProvider = controller
                    .preferencesProvider.preferences.value!.offlineMapProvider;
                return Text(mapProvider == null
                    ? 'none'.tr
                    : mapProvider.readableString);
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
                                        controller
                                            .preferencesProvider.preferences
                                            .update((val) {
                                          val?.language = lang;
                                        });
                                        Get.back();
                                      },
                                      child: Text(lang.readableString,
                                          style: TextStyle(
                                              color: controller
                                                          .preferencesProvider
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
                var language =
                    controller.preferencesProvider.preferences.value!.language;
                return Text(language.readableString);
              }),
            ),
          ],
        ),
      )),
    );
  }
}
