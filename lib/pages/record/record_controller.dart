import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/models/offline_record.dart';
import 'package:hikees/models/record.dart';
import 'package:hikees/pages/account/saved_records/saved_records_controller.dart';
import 'package:hikees/providers/offline.dart';
import 'package:hikees/providers/record.dart';
import 'package:hikees/utils/dialog.dart';

class RecordController extends GetxController with StateMixin<Record> {
  final _recordProvider = Get.put(RecordProvider());
  final _offlineProvider = Get.find<OfflineProvider>();
  bool offline = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['record'] != null) {
      OfflineRecord record = Get.arguments['record'];
      offline = true;
      append(() => () => Future.value(record));
    } else
      append(() => getRecord);
  }

  Future<Record> getRecord() {
    return _recordProvider.getRecord(int.parse(Get.parameters['id']!));
  }

  Future<void> delete() async {
    DialogUtils.showActionDialog(
        'warning'.tr, Center(child: Text('areYouSureYouWantToDelete'.tr)),
        critical: true, okText: 'yes'.tr, onOk: () {
      var id = state!.id;
      _offlineProvider.deleteOfflineRecord(id);
      SavedRecordsController savedRecordsController =
          Get.find<SavedRecordsController>();
      savedRecordsController.removeWhere((t) => t.id == id);
      Get.back();
      return true;
    });
  }
}
