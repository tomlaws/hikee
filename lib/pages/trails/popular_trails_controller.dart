import 'package:get/get.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/providers/trail.dart';

class PopularTrailsController extends GetxController
    with StateMixin<List<Trail>> {
  final _trailProvider = Get.put(TrailProvider());

  @override
  void onInit() {
    super.onInit();
    append(() => _load);
  }

  Future<List<Trail>> _load() async {
    var res = await _trailProvider.getPopularTrails();
    return res.data;
  }

  void refetch() {
    change(null, status: RxStatus.loading());
    append(() => _load);
  }
}
