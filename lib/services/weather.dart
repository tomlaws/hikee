import 'package:hikee/models/weather.dart';
import 'package:hikee/utils/http.dart';

class WeatherService {
  Future<Weather?> getWeather() async {
    try {
      Map<String, dynamic> queryParams = {'dataType': 'rhrread', 'lang': 'en'};
      final uri = Uri.https('data.weather.gov.hk',
          '/weatherAPI/opendata/weather.php', queryParams);
      var res = await HttpUtils.get(uri);
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
      return null;
    }
  }
}
