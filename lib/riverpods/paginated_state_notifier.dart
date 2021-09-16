import 'package:flutter/widgets.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class PaginatedStateNotifier<T extends Paginated?>
    extends StateNotifier<T?> {
  PaginatedStateNotifier(T? state) : super(state);
  String? query;
  String? cursor;
  String? sort;
  String? order = 'DESC';
  bool fetchingMore = false;

  Map<String, dynamic> getQueryParams() {
    Map<String, dynamic> queryParams = {};
    if (query != null && query!.length > 0) queryParams['query'] = query;
    if (cursor != null) queryParams['cursor'] = cursor;
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;
    return queryParams;
  }

  next() async {
    if (fetchingMore) return;
    cursor = state?.cursor;
    fetchingMore = true;
    var newData = await fetch(getQueryParams());
    if (state != null)
      state = state?.concat(newData as Paginated) as T?;
    else
      state = newData;
    WidgetsBinding.instance?.addPostFrameCallback((_) => fetchingMore = false); // Make sure UI updates first, then set fetchingMore to false
  }

  Future<T> fetch(Map<String, dynamic> queryParams);
}
