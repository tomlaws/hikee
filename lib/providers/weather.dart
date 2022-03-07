import 'package:get/get.dart';
import 'package:hikees/models/weather.dart';

class WeatherProvider extends GetConnect {
  Future<Weather> getWeather() async {
    var langMapping = {'HK': 'tc', 'TW': 'tc', 'CH': 'sc', 'US': 'en'};
    try {
      Map<String, dynamic> query = {
        'dataType': 'rhrread',
        'lang': langMapping[Get.locale?.countryCode] ?? 'en'
      };
      var res = (await get(
              'https://data.weather.gov.hk/weatherAPI/opendata/weather.php',
              query: query))
          .body;
      List<dynamic> temp = res['temperature']['data'];
      double celsius =
          temp.fold<double>(0.0, (prev, element) => prev + element['value']) /
              temp.length;
      return Weather(
          icon: List<int>.from(res['icon']),
          temperature: celsius.round(),
          warningMessage: res['warningMessage'] is String
              ? []
              : List<String>.from(res['warningMessage']));
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }
}
