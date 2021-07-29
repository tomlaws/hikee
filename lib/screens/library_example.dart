import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/screens/route.dart';
import 'package:hikee/services/route.dart';

class LibraryExampleScreen extends StatefulWidget {
  const LibraryExampleScreen({Key? key}) : super(key: key);

  @override
  _LibraryExampleScreenState createState() => _LibraryExampleScreenState();
}

class _LibraryExampleScreenState extends State<LibraryExampleScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  RouteService get _routeService => GetIt.I<RouteService>();
  TextEditingController _searchController = TextEditingController(text: '');
  ScrollController _scrollController = ScrollController();

  List<HikingRoute> _hikingRoutes = [];
  bool _loading = false;
  bool _hasMore = true;
  //late Future<List<HikingRoute>> _hikingRoutes;

  @override
  void initState() {
    super.initState();
    fetchMore();
    _scrollController.addListener(() {
      double diff = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (diff < 500 && !_loading && _hasMore) {
        fetchMore();
      }
    });
  }

  void fetchMore() async {
    setState(() {
      _loading = true;
    });
    int? after = _hikingRoutes.isEmpty ? null : _hikingRoutes.last.id;
    List<HikingRoute> routes = await _routeService.getRoutes(after: after);
    if (mounted)
      setState(() {
        if (routes.length > 0)
          _hikingRoutes.addAll(routes);
        else
          _hasMore = false;
        _loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextInput(
                    textEditingController: _searchController,
                    hintText: 'Search...',
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return HikingRouteTile(
                      route: _hikingRoutes[index],
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                RouteScreen(id: _hikingRoutes[index].id)));
                      },
                    );
                  }, childCount: _hikingRoutes.length),
                ),
              ),
              if (_loading && _hasMore)
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: CircularProgressIndicator(),
                  )),
                ),
            ],
          ),
        )
      ],
    );
  }
}
