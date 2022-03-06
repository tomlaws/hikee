import 'package:get/get.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/bookmark.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/user.dart';

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
}
