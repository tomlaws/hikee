import 'package:get/get.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/providers/offline.dart';

class OfflineTrailsController extends PaginationController<Trail> {
  final _OfflineProvider = Get.find<OfflineProvider>();
  int _count = 0;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<Paginated<Trail>> fetch(Map<String, dynamic> query) async {
    // cursor = offset
    List<Trail> trails = await _OfflineProvider.getTrails(_count);
    _count += trails.length;
    return Paginated(data: trails, hasMore: true, totalCount: totalCount);
  }

  @override
  Future<void> refetch() async {
    _count = 0;
    super.refetch();
  }
}
