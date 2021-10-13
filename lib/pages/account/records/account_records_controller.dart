import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/providers/record.dart';

class AccountRecordsController extends PaginationController<Paginated<Record>> {
  final _recordProvider = Get.put(RecordProvider());

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<Paginated<Record>> fetch(Map<String, dynamic> query) {
    return _recordProvider.getMyRecords(query);
  }
}
