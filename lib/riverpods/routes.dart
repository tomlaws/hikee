import 'package:hikee/api.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/riverpods/paginated_state_notifier.dart';
import 'package:hikee/utils/http.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routesProvider = StateNotifierProvider<Routes, Paginated<HikingRoute>?>((ref) {
  return Routes(ref);
});

class Routes extends PaginatedStateNotifier<Paginated<HikingRoute>?> {
  Routes(this.ref) : super(null);

  final ProviderRefBase ref;

  @override
  fetch(Map<String, dynamic> queryParams) async {
    final uri = API.getUri('/routes', queryParams: queryParams);
    dynamic paginated = await HttpUtils.get(uri);
    var data = Paginated<HikingRoute>.fromJson(
        paginated, (o) => HikingRoute.fromJson(o as Map<String, dynamic>));
    return data;
  }
}
