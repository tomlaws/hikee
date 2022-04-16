import 'dart:convert';

import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/record.dart';
import 'package:hikees/providers/shared/base.dart';
import 'package:hikees/utils/geo.dart';
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

  Future<Record> createRecord({
    required int time,
    required String name,
    int? referenceTrailId,
    required int regionId,
    required List<LatLng> userPath,
  }) async {
    var body = {
      'name': name,
      'time': time,
      'regionId': regionId,
      'userPath': GeoUtils.encodePath(userPath)
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
