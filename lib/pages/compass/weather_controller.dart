import 'dart:async';

import 'package:get/get.dart';
import 'package:hikees/models/weather.dart';
import 'package:hikees/providers/weather.dart';

class WeatherController extends GetxController with StateMixin<Weather> {
  final _weatherProvider = Get.put(WeatherProvider());
  Timer? _timer;
  int _interval = 0;

  @override
  void onInit() {
    super.onInit();
    _setupTimer(3);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _setupTimer(int seconds) {
    _timer?.cancel();
    _interval = seconds;
    _timer = Timer.periodic(Duration(seconds: seconds), (timer) {
      updateWeather();
      if (_interval < 300) {
        _setupTimer(300);
      }
    });
  }

  updateWeather() async {
    if (state == null) {
      append(() => _weatherProvider.getWeather);
    } else {
      change(await _weatherProvider.getWeather());
    }
  }
}
