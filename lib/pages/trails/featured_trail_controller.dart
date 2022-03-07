import 'package:get/get.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/providers/trail.dart';

class FeaturedTrailController extends GetxController with StateMixin<Trail> {
  final _trailProvider = Get.put(TrailProvider());

  @override
  void onInit() {
    super.onInit();
    append(() => _trailProvider.getFeaturedTrail);
  }

  void refetch() {
    change(null, status: RxStatus.loading());
    append(() => _trailProvider.getFeaturedTrail);
  }
}
