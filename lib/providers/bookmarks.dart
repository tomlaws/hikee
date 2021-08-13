import 'package:get_it/get_it.dart';
import 'package:hikee/models/auth.dart';
import 'package:hikee/models/bookmark.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/pagination_change_notifier.dart';
import 'package:hikee/services/bookmark.dart';

class BookmarksProvider extends PaginationChangeNotifier<Bookmark> {
  Auth _auth;
  set auth(auth) => _auth = auth;
  BookmarkService _bookmarkService = GetIt.I<BookmarkService>();

  BookmarksProvider({required Auth auth}) : _auth = auth;

  Future<Bookmark> createBookmark(int routeId) async {
    Bookmark bookmark = await _bookmarkService.createBookmark(_auth.getToken(),
        routeId: routeId);
    insert(0, bookmark);
    return bookmark;
  }

  deleteBookmark(int bookmarkId) async {
    await _bookmarkService.deleteBookmark(_auth.getToken(), id: bookmarkId);
    delete((element) => element.id == bookmarkId);
  }

  @override
  Future<Paginated<Bookmark>> get(cursor) async {
    return await _bookmarkService.getBookmarks(_auth.getToken(), cursor: cursor);
  }
}
