import 'package:flutter/cupertino.dart';
import 'package:hikee/models/paginated.dart';

abstract class PaginationChangeNotifier<T> extends ChangeNotifier {
  List<T> _items = [];
  get items => _items;

  String? _cursor;
  bool _hasMore = true;
  get hasMore => _hasMore;
  bool _loading = false;
  get loading => _loading;

  fetch(bool next) async {
    if (!next) {
      _cursor = null;
      _loading = false;
      _hasMore = true;
      _items.clear();
    }
    if (_loading || !_hasMore) return;
    _loading = true;
    notifyListeners();
    Paginated<T> paginated = await get(_cursor);
    _hasMore = paginated.hasMore;
    _cursor = paginated.cursor;
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

  Future<Paginated<T>> get(String? cursor);
}
