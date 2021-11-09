import 'package:get/get.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/providers/trail.dart';

class PopularTrailsController extends GetxController
    with StateMixin<List<Trail>> {
  final _trailProvider = Get.put(TrailProvider());

  @override
  void onInit() {
    super.onInit();
    append(() => () async {
          var res = await _trailProvider.getPopularTrails();
          return res.data;
        });
  }
}
