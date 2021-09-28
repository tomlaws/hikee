import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikee/models/paginated.dart';

abstract class PaginationController<T extends Paginated?> extends GetxController
    with StateMixin<T> {
  String? _query;
  String? cursor;
  String? sort;
  String? order = 'DESC';
  bool fetchingMore = false;

  Map<String, dynamic> getQueryParams() {
    Map<String, dynamic> queryParams = {};
    if (_query != null && _query!.length > 0) queryParams['query'] = _query;
    if (cursor != null) queryParams['cursor'] = cursor;
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;
    return queryParams;
  }

  next() async {
    if (fetchingMore) return;
    cursor = state?.cursor;
    fetchingMore = true;
    if (state != null)
      change(state, status: RxStatus.loadingMore());
    else
      change(state, status: RxStatus.loading());
    var newData = await fetch(getQueryParams());
    if (state != null)
      change(state?.concat(newData as Paginated) as T?,
          status: RxStatus.success());
    else
      change(newData, status: RxStatus.success());
    WidgetsBinding.instance?.addPostFrameCallback((_) => fetchingMore =
        false); // Make sure UI updates first, then set fetchingMore to false, otherwise UI will fetch next page again
  }

  _clear() {
    cursor = null;
    fetchingMore = false;
    change(null, status: RxStatus.loading());
  }

  refetch() {
    _clear();
    next();
  }

  set query(String query) {
    _clear();
    _query = query;
    next();
  }

  Future<T> fetch(Map<String, dynamic> queryParams);
}
