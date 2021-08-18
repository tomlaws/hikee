import 'package:get_it/get_it.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/route_review.dart';
import 'package:hikee/providers/pagination_change_notifier.dart';
import 'package:hikee/providers/route.dart';
import 'package:hikee/services/route.dart';

class RouteReviewsProvider extends PaginationChangeNotifier<RouteReview> {
  AuthProvider _authProvider;
  RouteProvider _routeProvider;
  RouteService _routeService = GetIt.I<RouteService>();

  RouteReviewsProvider({required AuthProvider authProvider, required RouteProvider routeProvider}) : _authProvider = authProvider, _routeProvider = routeProvider;

  Future<RouteReview> createRouteReview(
      int routeId, String content, int rating) async {
    RouteReview review = await _routeService.createRouteReview(_authProvider.getToken(),
        content: content, rating: rating, routeId: routeId);
    insert(0, review);
    return review;
  }

  @override
  Future<Paginated<RouteReview>> get(cursor) async {
    return await _routeService.getRouteReviews(_routeProvider.route?.id ?? 1, cursor: cursor);
  }
}
