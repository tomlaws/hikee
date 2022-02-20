import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/record.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/pages/trails/trails_controller.dart';
import 'package:hikee/providers/record.dart';
import 'package:hikee/providers/user.dart';

class ProfileController extends PaginationController<Record> {
  final _recordProvider = Get.put(RecordProvider());
  final userProvider = Get.put(UserProvider());
  late int userId;
  final user = Rxn<User>(null);

  Set<int> regions = {...defaultRegions};
  int minDuration = defaultMinDuration;
  int maxDuration = defaultMaxDuration;
  int minLength = defaultMinLength;
  int maxLength = defaultMaxLength;

  @override
  void onInit() {
    super.onInit();
    userId = int.parse(Get.parameters['id']!);
    userProvider.getUser(userId).then((user) {
      this.user.value = user;
    });
  }

  @override
  Future<Paginated<Record>> fetch(Map<String, dynamic> query) {
    if (minDuration != defaultMinDuration) {
      query['minDuration'] = minDuration.toString();
    }
    if (maxDuration != defaultMaxDuration) {
      query['maxDuration'] = maxDuration.toString();
    }
    if (minLength != defaultMinLength) {
      query['maxDuration'] = maxDuration.toString();
    }
    if (minLength != defaultMinLength) {
      query['minLength'] = minLength.toString();
    }
    if (maxLength != defaultMaxLength) {
      query['maxLength'] = maxLength.toString();
    }
    if (!regions.containsAll(defaultRegions)) {
      query['regionIds'] = regions.toList().toString();
    }
    return _recordProvider.getUserRecords(userId, query);
  }
}
