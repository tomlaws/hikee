import 'package:hikee/api.dart';
import 'package:hikee/models/bookmark.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/utils/http.dart';

class BookmarkService {
  Future<Paginated<Bookmark>> getBookmarks(Future<Token?> token,
      {String? query,
      String? cursor,
      String? sort,
      String? order = 'DESC'}) async {
    Map<String, String> queryParams = {};
    if (query != null && query.length > 0) queryParams['query'] = query;
    if (cursor != null) queryParams['cursor'] = cursor;
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;

    final uri = API.getUri('/bookmarks', queryParams: queryParams);
    dynamic paginated =
        await HttpUtils.get(uri, accessToken: (await token)?.accessToken);
    return Paginated<Bookmark>.fromJson(
        paginated, (o) => Bookmark.fromJson(o as Map<String, dynamic>));
  }

  Future<Bookmark> createBookmark(Future<Token?> token,
      {required int routeId}) async {
    final uri = API.getUri('/bookmarks');
    dynamic res = await HttpUtils.post(uri, {'routeId': routeId},
        accessToken: (await token)?.accessToken);
    return Bookmark.fromJson(res);
  }

  Future<bool> deleteBookmark(Future<Token?> token,
      {required int id}) async {
    final uri = API.getUri('/bookmarks/$id');
    dynamic res =
        await HttpUtils.delete(uri, accessToken: (await token)?.accessToken);
    return res;
  }
}
