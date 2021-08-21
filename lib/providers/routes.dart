import 'package:get_it/get_it.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/pagination_change_notifier.dart';
import 'package:hikee/services/route.dart';
import 'package:tuple/tuple.dart';

class RoutesProvider extends PaginationChangeNotifier<HikingRoute> {
  RouteService _routeService = GetIt.I<RouteService>();
  String _query = '';
  String get query => query;
  String _sort = 'length';
  String get sort => _sort;
  String _order = 'ASC';
  String get order => _order;
  int? _regionId;
  int? get regionId => _regionId;

  int _minDifficulty = 1;
  int get minDifficulty => _minDifficulty;
  int _maxDifficulty = 5;
  int get maxDifficulty => _maxDifficulty;

  int _minRating = 1;
  int get minRating => _minRating;
  int _maxRating = 5;
  int get maxRating => _maxRating;

  int _minDuration = 0;
  int get minDuration => _minDuration;
  int _maxDuration = 720;
  int get maxDuration => _maxDuration;

  int _minLength = 0;
  int get minLength => _minLength;
  int _maxLength = 20000;
  int get maxLength => _maxLength;

  var _sortMap = {
    'difficulty': 'Difficulty',
    'length': 'Length',
    'duration': 'Duration',
  };
  String get sortStr => _sortMap[_sort]!;

  Map<int, String> _regionMap = {
    1: 'North New Territories',
    2: 'Hong Kong Island',
    3: 'Central New Territories',
    4: 'Sai Kung',
    5: 'West New Territories',
    6: 'Lantau'
  };
  Map<int, String> get regions => _regionMap;
  String get regionStr => _regionMap[regionId]!;

  RoutesProvider();

  @override
  Future<Paginated<HikingRoute>> get(cursor) async {
    return await _routeService.getRoutes(
        cursor: cursor,
        query: _query,
        sort: _sort,
        order: _order,
        regionId: _regionId,
        minDifficulty: _minDifficulty,
        maxDifficulty: _maxDifficulty,
        minRating: _minRating,
        maxRating: _maxRating,
        minDuration: _minDuration,
        maxDuration: _maxDuration,
        minLength: _minLength,
        maxLength: _maxLength);
  }

  set sort(String sort) {
    if (_sort == sort) return;
    _sort = sort;
    fetch(false);
    notifyListeners();
  }

  set query(String query) {
    if (_query == query) return;
    _query = query;
    fetch(false);
    notifyListeners();
  }

  set order(String order) {
    if (_order == order) return;
    _order = order;
    fetch(false);
    notifyListeners();
  }

  void clearFilters() {
    _regionId = null;

    _minDifficulty = 1;
    _maxDifficulty = 5;

    _minRating = 1;
    _maxRating = 5;

    _minDuration = 0;
    _maxDuration = 720;

    _minLength = 0;
    _maxLength = 20000;
    fetch(false);
    notifyListeners();
  }

  void applyFilters(
      {int? regionId,
      int minDifficulty = 1,
      int maxDifficulty = 5,
      int minRating = 1,
      int maxRating = 5,
      int minLength = 0,
      int maxLength = 20000,
      int minDuration = 0,
      int maxDuration = 720}) {
    _regionId = regionId;
    _minDifficulty = minDifficulty;
    _maxDifficulty = maxDifficulty;
    _minRating = minRating;
    _maxRating = maxRating;
    _minLength = minLength;
    _maxLength = maxLength;
    _minDuration = minDuration;
    _maxDuration = maxDuration;
    fetch(false);
    notifyListeners();
  }
}
