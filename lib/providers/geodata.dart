import 'package:hikee/models/facility.dart';
import 'package:hikee/providers/shared/base.dart';
import 'package:hikee/utils/geo.dart';
import 'package:latlong2/latlong.dart';
import 'package:tuple/tuple.dart';

class GeodataProvider extends BaseProvider {
  @override
  String getUrl() {
    var endpoint = "http://geodata.gov.hk/";
    return endpoint;
  }

  Future<List<Facility>> getNearbyFacilities(LatLng location) async {
    Tuple2 transformResult = GeoUtils.convertToEPSG2326(location);
    var url =
        'gs/api/v1.0.0/searchNearby?x=${transformResult.item1.toString()}&y=${transformResult.item2.toString()}';
    print(url);
    return await get(url).then((value) {
      return (value.body as List).map((e) => Facility.fromJson(e)).toList();
    });
  }
}
