import 'package:get/get.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/bookmark.dart';
import 'package:hikees/models/paginated.dart';
import 'package:hikees/providers/user.dart';

class AccountBookmarksController extends PaginationController<Bookmark> {
  final _userProvider = Get.put(UserProvider());

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Future<Paginated<Bookmark>> fetch(Map<String, dynamic> query) {
    return _userProvider.getBookmarks(query);
  }

  remove(int trailId) {
    if (state == null) return;
    state!.data.removeWhere((element) => element.trailId == trailId);
    change(state, status: RxStatus.success());
  }
}
