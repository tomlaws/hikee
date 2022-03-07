import 'package:get/get.dart';
import 'package:hikees/models/record.dart';
import 'package:hikees/providers/record.dart';

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
