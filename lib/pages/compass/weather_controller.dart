import 'dart:async';

import 'package:get/get.dart';
import 'package:hikees/models/weather.dart';
import 'package:hikees/providers/weather.dart';

class WeatherController extends GetxController with StateMixin<Weather> {
  final _weatherProvider = Get.put(WeatherProvider());
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    append(() => _weatherProvider.getWeather);
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      updateWeather();
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  updateWeather() async {
    change(await _weatherProvider.getWeather());
  }
}
