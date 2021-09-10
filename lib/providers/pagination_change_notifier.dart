import 'package:flutter/cupertino.dart';
import 'package:hikee/models/order.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/utils/enum.dart';

abstract class PaginationChangeNotifier<T> extends ChangeNotifier {
  List<T> _items = [];
  List<T> get items => _items;

  String? _cursor;
  bool _hasMore = true;
  get hasMore => _hasMore;
  int _totalCount = 0;
  get totalCount => _totalCount;
  bool _loading = true;
  get loading => _loading;
  int _fetchCount = 0;
  get fetchCount => _fetchCount;

  fetch(bool next) async {
    if (!next) {
      clearState();
    }
    if (_loading || !_hasMore) return;
    _loading = true;
    _fetchCount++;
    notifyListeners();
    Paginated<T> paginated = await get(cursor: _cursor);
    _hasMore = paginated.hasMore;
    _cursor = paginated.cursor;
    _totalCount = paginated.totalCount;
    _loading = false;
    _items.addAll(paginated.data);
    notifyListeners();
  }

  insert(int index, T element) {
    _items.insert(index, element);
    notifyListeners();
  }

  delete(bool Function(T) test) {
    _items.removeWhere(test);
    notifyListeners();
  }

  clearState() {
    _cursor = null;
    _loading = false;
    _hasMore = true;
    _items.clear();
    _fetchCount = 0;
    notifyListeners();
  }

  Future<Paginated<T>> get({String? cursor});
}

/// Different from [PaginationChangeNotifier], it offers [sort], [order] and [query] parameters
abstract class AdvancedPaginationChangeNotifier<T, U>
    extends PaginationChangeNotifier<T> {
  AdvancedPaginationChangeNotifier({
    required List<U> sortable,
    required U defaultSort,
    Order defaultOrder = Order.DESC,
  }) : _sortable = sortable {
    _sort = EnumUtil.string(defaultSort as Object);
    _order = EnumUtil.string(defaultOrder);
  }

  final List<U> _sortable;

  String? _query;
  String? get query => _query;
  late String _sort;
  U get sort => EnumUtil.fromString(_sortable, _sort);
  late String _order;
  Order get order => EnumUtil.fromString(Order.values, _order);

  @override
  fetch(bool next) async {
    if (!next) {
      clearState();
    }
    if (_loading || !_hasMore) return;
    _loading = true;
    _fetchCount++;
    notifyListeners();
    Paginated<T> paginated =
        await get(cursor: _cursor, sort: _sort, order: _order, query: _query);
    _hasMore = paginated.hasMore;
    _cursor = paginated.cursor;
    _items.addAll(paginated.data);
    _loading = false;
    notifyListeners();
  }

  set sort(U sort) {
    if (_sort == EnumUtil.string(sort as Object)) return;
    _sort = EnumUtil.string(sort);
    fetch(false);
    notifyListeners();
  }

  set query(String? query) {
    if (query == '') query = null;
    if (_query == query) return;
    _query = query;
    fetch(false);
    notifyListeners();
  }

  set order(Order order) {
    if (_order == EnumUtil.string(order)) return;
    _order = EnumUtil.string(order);
    fetch(false);
    notifyListeners();
  }

  @override
  Future<Paginated<T>> get(
      {String? cursor, String? sort, String? order, String? query});
}
