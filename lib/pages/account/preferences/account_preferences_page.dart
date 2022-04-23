import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide TextInput;
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/models/preferences.dart';
import 'package:hikees/pages/account/account_page.dart';
import 'package:hikees/pages/account/preferences/account_preferences_controller.dart';
import 'package:hikees/providers/preferences.dart';
import 'package:hikees/themes.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:hikees/utils/geo.dart';

class AccountPreferencesPage extends GetView<AccountPreferencesController> {
  final formkey = GlobalKey<FormState>();
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
                DialogUtils.showSimpleDialog(
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
                DialogUtils.showSimpleDialog(
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
                var flatSpeed = controller
                    .preferencesProvider.preferences.value!.flatSpeedInKm;
                var climbSpeed = controller
                    .preferencesProvider.preferences.value!.climbSpeedInM;
                DialogUtils.showActionDialog(
                    'speed'.tr,
                    Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextInput(
                            initialValue: flatSpeed.toString(),
                            label: 'flatSpeed'.tr + ' (km/h)',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (v) {
                              int speed = int.tryParse(v ?? '0') ?? 0;
                              if (speed <= 0 || speed > 20) {
                                return 'fieldMustWithinRange'.trParams({
                                  'field': 'flatSpeed'.tr,
                                  'min': '1',
                                  'max': '20'
                                });
                              }
                              return null;
                            },
                            onSaved: (v) {
                              controller.preferencesProvider.preferences
                                  .update((val) {
                                val!.flatSpeedInKm = int.parse(v!);
                              });
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextInput(
                            initialValue: climbSpeed.toString(),
                            label: 'climbSpeed'.tr + ' (m/h)',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (v) {
                              int speed = int.tryParse(v ?? '0') ?? 0;
                              if (speed <= 100 || speed > 2000) {
                                return 'fieldMustWithinRange'.trParams({
                                  'field': 'climbSpeed'.tr,
                                  'min': '100',
                                  'max': '2000'
                                });
                              }
                              return null;
                            },
                            onSaved: (v) {
                              controller.preferencesProvider.preferences
                                  .update((val) {
                                val!.climbSpeedInM = int.parse(v!);
                              });
                            },
                          ),
                        ],
                      ),
                    ), onOk: () {
                  if (formkey.currentState?.validate() == true) {
                    formkey.currentState!.save();
                    return true;
                  } else {
                    throw new Error();
                  }
                });
              },
              title: "speed".tr,
              trailing: Obx(() {
                var mapProvider = controller
                    .preferencesProvider.preferences.value!.offlineMapProvider;
                return Text(mapProvider == null
                    ? '${GeoUtils.formatKm(controller.preferencesProvider.preferences.value!.flatSpeedInKm.toDouble())} / ${GeoUtils.formatMetres(controller.preferencesProvider.preferences.value!.climbSpeedInM)}'
                    : mapProvider.readableString);
              }),
            ),
            MenuListTile(
              onTap: () {
                DialogUtils.showSimpleDialog(
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
