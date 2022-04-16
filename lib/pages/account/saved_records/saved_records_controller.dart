import 'package:get/get.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/offline_record.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/providers/offline.dart';

class SavedRecordsController extends PaginationController<OfflineRecord> {
  final _offlineProvider = Get.find<OfflineProvider>();
  int _count = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<Paginated<OfflineRecord>> fetch(Map<String, dynamic> query) async {
    // cursor = offset
    List<OfflineRecord> records =
        await _offlineProvider.getOfflineRecords(_count);
    _count += records.length;
    return Paginated(data: records, hasMore: true, totalCount: totalCount);
  }

  @override
  Future<void> refetch() async {
    _count = 0;
    super.refetch();
  }
}
