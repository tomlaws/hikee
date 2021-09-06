import 'package:get_it/get_it.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/models/bookmark.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/pagination_change_notifier.dart';
import 'package:hikee/services/bookmark.dart';

class BookmarksProvider extends PaginationChangeNotifier<Bookmark> {
  AuthProvider _authProvider;
  BookmarkService _bookmarkService = GetIt.I<BookmarkService>();

  BookmarksProvider({required AuthProvider authProvider}) : _authProvider = authProvider;

  update({required AuthProvider authProvider}) {
    this._authProvider = authProvider;
  }

  Future<Bookmark> createBookmark(int routeId) async {
    Bookmark bookmark = await _bookmarkService.createBookmark(_authProvider.getToken(),
        routeId: routeId);
    insert(0, bookmark);
    return bookmark;
  }

  deleteBookmark(int bookmarkId) async {
    await _bookmarkService.deleteBookmark(_authProvider.getToken(), id: bookmarkId);
    delete((element) => element.id == bookmarkId);
  }

  @override
  Future<Paginated<Bookmark>> get({ String? cursor }) async {
    return await _bookmarkService.getBookmarks(_authProvider.getToken(), cursor: cursor);
  }

}