import 'package:hikees/pages/compass/compass_controller.dart';
import 'package:get/get.dart';
import 'package:hikees/pages/compass/weather_controller.dart';

class CompassBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompassController());
    Get.lazyPut(() => WeatherController());
  }
}
