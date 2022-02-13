import 'dart:convert';

import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/providers/shared/base.dart';
import 'package:hikee/utils/geo.dart';
import 'package:latlong2/latlong.dart';

class RecordProvider extends BaseProvider {
  Future<Paginated<Record>> getMyRecords(Map<String, dynamic>? query) async {
    return await get('users/records', query: query).then((value) {
      return Paginated<Record>.fromJson(
          value.body, (o) => Record.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<Paginated<Record>> getMyRecordsInDays(
      Map<String, dynamic>? query) async {
    return await get('users/records', query: query).then((value) {
      return Paginated<Record>.fromJson(
          value.body, (o) => Record.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<Paginated<Record>> getUserRecords(
      int userId, Map<String, dynamic>? query) async {
    return await get('users/${userId.toString()}/records', query: query)
        .then((value) {
      return Paginated<Record>.fromJson(
          value.body, (o) => Record.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<Record> createRecord(
      {required DateTime date,
      required int time,
      required String name,
      int? referenceTrailId,
      required int regionId,
      required int length,
      required List<LatLng> userPath,
      required List<double> altitudes}) async {
    if (altitudes.length > 48) {
      List<double> minimized = [];
      altitudes.asMap().forEach((index, value) {
        if (index % (altitudes.length / 48).ceil() == 0)
          return minimized.add(value);
      });
      altitudes = minimized;
    }
    var body = {
      'name': name,
      'date': date.toString(),
      'time': time,
      'regionId': regionId,
      'userPath': GeoUtils.encodePath(userPath),
      'length': length,
      'altitudes': altitudes
    };
    if (referenceTrailId != null) {
      body['referenceTrailId'] = referenceTrailId;
    }
    return await post('records', body).then((value) {
      return Record.fromJson(value.body);
    });
  }

  Future<Record> getRecord(int id) async {
    return await get('records/$id').then((value) {
      return Record.fromJson(value.body);
    });
  }
}
