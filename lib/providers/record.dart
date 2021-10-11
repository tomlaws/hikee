import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/providers/shared/base.dart';

class RecordProvider extends BaseProvider {
  Future<Paginated<Record>> getMyRecords(Map<String, dynamic>? query) async {
    return await get('me/records', query: query).then((value) {
      return Paginated<Record>.fromJson(
          value.body, (o) => Record.fromJson(o as Map<String, dynamic>));
    });
  }

  Future<Record> createRecord(
      {required DateTime date, required int time, required int routeId}) async {
    return await post('records', {
      'date': date.toString(),
      'time': time,
      'routeId': routeId
    }).then((value) {
      return Record.fromJson(value.body);
    });
  }
}
