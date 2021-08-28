import 'package:get_it/get_it.dart';
import 'package:hikee/models/order.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/pagination_change_notifier.dart';
import 'package:hikee/services/route.dart';

class RoutesProvider
    extends AdvancedPaginationChangeNotifier<HikingRoute, HikingRouteSortable> {
  RouteService _routeService = GetIt.I<RouteService>();

  int? _regionId;
  Region? get region =>
      _regionId == null ? null : Region.values[_regionId! + 1];

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

  RoutesProvider()
      : super(
            sortable: HikingRouteSortable.values,
            defaultSort: HikingRouteSortable.rating,
            defaultOrder: Order.DESC);

  @override
  Future<Paginated<HikingRoute>> get(
      {String? cursor, String? query, String? sort, String? order}) async {
    return await _routeService.getRoutes(
        cursor: cursor,
        query: query,
        sort: sort,
        order: order,
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

enum HikingRouteSortable { difficulty, length, duration, rating }

extension HikingRoutesSortableExtension on HikingRouteSortable {
  String get name {
    return ['Difficulty', 'Length', 'Duration', 'Rating'][this.index];
  }
}

enum Region {
  NORTH_NEW_TERRITORIES, //1
  HONG_KONG_ISLAND, //2
  CENTRAL_NEW_TERRITORIES, //3
  SAI_KUNG, //4
  WEST_NEW_TERRITORIES, //5
  LANTAU //6
}

extension RegionExtension on Region {
  String get name {
    return [
      'North New Territories',
      'Hong Kong Island',
      'Central New Territories',
      'Sai Kung',
      'West New Territories',
      'Lantau'
    ][this.index];
  }

  int get id {
    return this.index + 1;
  }
}
