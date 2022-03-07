import 'package:get/get.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/models/event.dart';
import 'package:hikees/providers/event.dart';
import 'package:hikees/providers/user.dart';

class AccountEventsController extends PaginationController<Event> {
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
