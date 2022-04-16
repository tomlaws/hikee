import 'package:get/get.dart';
import 'package:hikees/models/offline_record.dart';
import 'package:hikees/models/record.dart';
import 'package:hikees/providers/record.dart';

class RecordController extends GetxController with StateMixin<Record> {
  final _recordProvider = Get.put(RecordProvider());
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
}
