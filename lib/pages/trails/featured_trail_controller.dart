import 'package:get/get.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/providers/trail.dart';

class FeaturedTrailController extends GetxController with StateMixin<Trail> {
  final _trailProvider = Get.put(TrailProvider());

  @override
  void onInit() {
    super.onInit();
    append(() => _trailProvider.getFeaturedTrail);
  }
}
