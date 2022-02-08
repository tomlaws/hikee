// import 'package:hikee/models/facility.dart';
// import 'package:hikee/providers/shared/base.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:tuple/tuple.dart';

// class GeodeticProvider extends BaseProvider {
//   @override
//   String getUrl() {
//     var endpoint = "http://www.geodetic.gov.hk/";
//     return endpoint;
//   }

//   Future<Tuple2<double, double>> hk80ToWgs(LatLng location) async {
//     Map<String, dynamic> transformResult = (await get(
//             'transform/v2/?inSys=wgsgeog&outSys=hkgrid&lat=${location.latitude.toString()}&long=${location.longitude.toString()}'))
//         .body;
//     double easting = transformResult['hkE'] ?? 0;
//     double northing = transformResult['hkN'] ?? 0;
//     return Tuple2(easting, northing);
//   }

//   Future<List<Facility>> getNearbyFacilities(LatLng location) async {
//     Tuple2 transformResult = await hk80ToWgs(location);
//     return await get(
//             'gs/api/v1.0.0/searchNearby?x=${transformResult.item1.toString()}&y=${transformResult.item2.toString()}')
//         .then((value) {
//       return (value.body as List).map((e) => Facility.fromJson(e)).toList();
//     });
//   }
// }
