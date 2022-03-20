import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/models/preferences.dart';
import 'package:hikees/providers/preferences.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class AccountPreferencesController extends GetxController {
  final preferencesProvider = Get.find<PreferencesProvider>();
  final offlineMapAvailability = Rx<Map<MapProvider, bool>>({});
  final recv = 0.obs;
  final total = 0.obs;

  @override
  void onInit() {
    super.onInit();

    MapProvider.values.forEach((mapProvider) {
      _checkMapExist(mapProvider)
          .then((exist) => offlineMapAvailability.value[mapProvider] = exist);
    });
  }

  Future<bool> _checkMapExist(MapProvider mapProvider) async {
    final name = mapProvider.resIdentifier;
    try {
      final appDocDir =
          (await getApplicationDocumentsDirectory()).absolute.path;
      final file = File('$appDocDir/$name.mbtiles');
      var exists = file.existsSync();
      return exists;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  //https://api.github.com/repos/tomlaws/hkmbtiles/releases/latest
  Future<void> updateOfflineMapProvider(MapProvider? mapProvider) async {
    if (mapProvider != null) {
      // Check mbtiles exist
      bool ok = await _checkMapExist(mapProvider);
      if (!ok) {
        // download .mbtiles first
        await _download(mapProvider);
      }
    }
    preferencesProvider.preferences.update((val) {
      val?.offlineMapProvider = mapProvider;
    });
    Get.back();
  }

  Future<void> _download(MapProvider mapProvider) async {
    final name = mapProvider.toString().split('.').last;
    final downloadUrl =
        'https://github.com/tomlaws/hkmbtiles/releases/download/MapTiles/$name.mbtiles';
    var dio = Dio();
    final appDocDir = (await getApplicationDocumentsDirectory()).absolute.path;
    final file = File('$appDocDir/$name.mbtiles');
    // ProgressDialog pd = ProgressDialog(context: Get.context);
    // pd.show(
    //   max: 100,
    //   msg: 'downloading'.tr + '...',
    //   progressBgColor: Colors.black12,
    //   progressValueColor: Get.theme.primaryColor,
    //   msqFontWeight: FontWeight.normal,
    //   barrierColor: Colors.black54,
    // );
    total.value = 0;
    recv.value = 0;
    CancelToken cancelToken = CancelToken();
    DialogUtils.showDialog(
        "downloading".tr,
        Obx(() => total.value != 0
            ? Column(children: [
                Text((((recv.value / total.value) * 100).toInt()).toString() +
                    "%"),
                SizedBox(
                  height: 8,
                ),
                Text(
                    (recv.value / 1048576).toStringAsFixed(2) +
                        '/' +
                        (total.value / 1048576).toStringAsFixed(2) +
                        'MB',
                    style: TextStyle(fontSize: 11, color: Colors.black54)),
              ])
            : SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ))),
        dismissText: "cancel".tr, onDismiss: () {
      cancelToken.cancel();
    });
    var response = await dio.download(
      downloadUrl,
      file.absolute.path + '.tmp',
      cancelToken: cancelToken,
      onReceiveProgress: (r, t) {
        recv.value = r;
        total.value = t;
        int progress = (((r / t) * 100).toInt());
      },
    );
    final tmpFile = File('$appDocDir/$name.mbtiles.tmp');
    tmpFile.renameSync('$appDocDir/$name.mbtiles');
    Get.back();
  }
}
