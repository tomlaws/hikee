import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikee/models/paginated.dart';

typedef PaginationController<T> = InternalPaginationController<Paginated<T>, T>;

abstract class InternalPaginationController<T extends Paginated<U>, U>
    extends GetxController with StateMixin<T> {
  String? _query;
  String? cursor;
  String? sort;
  String? order = 'DESC';
  bool fetchingMore = false;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Map<String, dynamic> getQueryParams() {
    Map<String, dynamic> queryParams = {};
    if (_query != null && _query!.length > 0) queryParams['query'] = _query;
    if (cursor != null) queryParams['cursor'] = cursor;
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;
    return queryParams;
  }

  next() async {
    if (state?.hasMore == false) return;
    if (fetchingMore) return;
    cursor = state?.cursor;
    fetchingMore = true;
    if (state != null)
      change(state, status: RxStatus.loadingMore());
    else
      change(state, status: RxStatus.loading());
    var newData = await fetch(getQueryParams());
    // if (newData.data.length == 0) {
    //   change(state, status: RxStatus.success());
    //   return;
    // }
    if (state != null)
      change(state?.concat(newData) as T?, status: RxStatus.success());
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

  Future<void> refetch() async {
    _clear();
    await next();
  }

  set query(String query) {
    _clear();
    _query = query;
    next();
  }

  bool get hasMore {
    return state?.hasMore ?? false;
  }

  int get totalCount {
    return state?.totalCount ?? 0;
  }

  forceUpdate(T? newState) {
    change(newState as T, status: RxStatus.success());
  }

  Future<T> fetch(Map<String, dynamic> queryParams);
}

class GetPaginationController<T> extends PaginationController<T> {
  late Future<Paginated<T>> Function(Map<String, dynamic> query) _fetch;

  GetPaginationController(
      Future<Paginated<T>> fetch(Map<String, dynamic> query)) {
    this._fetch = fetch;
  }

  @override
  Future<Paginated<T>> fetch(Map<String, dynamic> queryParams) {
    return this._fetch(queryParams);
  }
}
