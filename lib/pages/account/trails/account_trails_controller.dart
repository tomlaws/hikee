import 'package:get/get.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/providers/auth.dart';
import 'package:hikees/providers/trail.dart';

class AccountTrailsController extends PaginationController<Trail> {
  final _trailProvider = Get.put(TrailProvider());
  final _authProvider = Get.find<AuthProvider>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<Paginated<Trail>> fetch(Map<String, dynamic> query) {
    query['creatorId'] = _authProvider.me.value?.id.toString();
    return _trailProvider.getTrails(query);
  }
}
