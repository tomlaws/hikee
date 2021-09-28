import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/providers/event.dart';
import 'package:hikee/providers/user.dart';

class AccountEventsController extends PaginationController<Paginated<Event>> {
  final _userProvider = Get.put(UserProvider());

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<Paginated<Event>> fetch(Map<String, dynamic> query) {
    return _userProvider.getEvents(query);
  }
}
