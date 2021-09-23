import 'package:get/get.dart';
import 'package:hikee/models/weather.dart';
import 'package:hikee/providers/weather.dart';

class WeatherController extends GetxController with StateMixin<Weather> {
  final _weatherProvider = Get.put(WeatherProvider());

  @override
  void onInit() {
    super.onInit();
    append(() => _weatherProvider.getWeather);
  }
}
