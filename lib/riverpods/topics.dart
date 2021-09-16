import 'package:hikee/api.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/riverpods/paginated_state_notifier.dart';
import 'package:hikee/utils/http.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final topicsProvider = StateNotifierProvider<Topics, Paginated<Topic>?>((ref) {
  return Topics(ref);
});

class Topics extends PaginatedStateNotifier<Paginated<Topic>?> {
  Topics(this.ref) : super(null);

  final ProviderRefBase ref;

  @override
  fetch(Map<String, dynamic> queryParams) async {
    final uri = API.getUri('/topics', queryParams: queryParams);
    dynamic paginated = await HttpUtils.get(uri);
    var data = Paginated<Topic>.fromJson(
        paginated, (o) => Topic.fromJson(o as Map<String, dynamic>));
    return data;
  }
}
