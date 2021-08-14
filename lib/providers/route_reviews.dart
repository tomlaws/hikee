import 'package:get_it/get_it.dart';
import 'package:hikee/models/auth.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/route_review.dart';
import 'package:hikee/providers/pagination_change_notifier.dart';
import 'package:hikee/services/route.dart';

class RouteReviewsProvider extends PaginationChangeNotifier<RouteReview> {
  Auth _auth;
  set auth(auth) => _auth = auth;
  RouteService _routeService = GetIt.I<RouteService>();

  int? _routeId = null;

  RouteReviewsProvider({required Auth auth}) : _auth = auth;

  Future<RouteReview> createRouteReview(
      int routeId, String content, int rating) async {
    RouteReview review = await _routeService.createRouteReview(_auth.getToken(),
        content: content, rating: rating, routeId: routeId);
    insert(0, review);
    return review;
  }

  void setRouteId(int id) {
    _routeId = id;
    clearState();
  }

  @override
  Future<Paginated<RouteReview>> get(cursor) async {
    return await _routeService.getRouteReviews(_routeId ?? 1, cursor: cursor);
  }
}
