import 'package:get/get.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/providers/route.dart';

class PopularRoutesController extends GetxController
    with StateMixin<List<HikingRoute>> {
  final _routeProvider = Get.put(RouteProvider());

  @override
  void onInit() {
    super.onInit();
    append(() => () async {
          var res = await _routeProvider.getPopularRoutes();
          return res.data;
        });
  }
}
