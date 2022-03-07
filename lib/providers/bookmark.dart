import 'package:hikees/models/bookmark.dart';
import 'package:hikees/providers/shared/base.dart';

class BookmarkProvider extends BaseProvider {
  Future<bool> removeBookmark(int trailId) async {
    await delete('bookmarks?trailId=${trailId.toString()}');
    return true;
  }

  Future<Bookmark> createBookmark(int trailId) async {
    return await post('bookmarks', {'trailId': trailId}).then((value) {
      return Bookmark.fromJson(value.body);
    });
  }
}
