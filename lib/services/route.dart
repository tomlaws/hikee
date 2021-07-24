import 'package:hikee/models/elevation.dart';
import 'package:hikee/utils/http.dart';

class RouteService {
  Future<List<Elevation>> getElevations(int routeId) async {
    List<dynamic> e = await HttpUtils.get(Uri.parse('https://hikee-staging.herokuapp.com/routes/$routeId/elevation'));
    return e.map((e) => Elevation.fromJson(e)).toList();
  }
}