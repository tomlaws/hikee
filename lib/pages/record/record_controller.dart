import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/providers/record.dart';

class RecordController extends GetxController with StateMixin<Record> {
  final _recordProvider = Get.put(RecordProvider());

  @override
  void onInit() {
    super.onInit();
    append(() => getRecord);
  }

  Future<Record> getRecord() {
    return _recordProvider.getRecord(int.parse(Get.parameters['id']!));
  }
}
