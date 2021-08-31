import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/core/infinite_scroll.dart';
import 'package:hikee/components/routes_filter.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/models/order.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/providers/routes.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({Key? key}) : super(key: key);

  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  TextEditingController _searchController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: HikeeAppBar(
        height: 112,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextInput(
                textEditingController: _searchController,
                hintText: 'Search...',
                textInputAction: TextInputAction.search,
                icon: Icon(Icons.search),
                onSubmitted: (q) {
                  context.read<RoutesProvider>().query = q;
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Button(
                      backgroundColor: Color(0xFFF5F5F5),
                      child: Selector<RoutesProvider,
                          Tuple2<HikingRouteSortable, Order>>(
                        selector: (_, p) => Tuple2(p.sort, p.order),
                        builder: (_, sortAndOrder, __) => Row(
                          children: [
                            sortAndOrder.item2 == Order.DESC
                                ? Icon(Icons.sort)
                                : Transform.rotate(
                                    angle: 180 * pi / 180,
                                    child: Icon(Icons.sort)),
                            Expanded(
                              child: Center(
                                child: Text(
                                  sortAndOrder.item1.name,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        _showSortMenu();
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Button(
                      backgroundColor: Color(0xFFF5F5F5),
                      onPressed: () {
                        _showFilter();
                      },
                      child: Text('Filters',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: InfiniteScroll<RoutesProvider, HikingRoute>(
            selector: (p) => p.items,
            builder: (route) {
              return HikingRouteTile(
                route: route,
                onTap: () {
                  Routemaster.of(context).push('/routes/${route.id}');
                },
              );
            },
            fetch: (next) {
              return context.read<RoutesProvider>().fetch(next);
            },
          ),
        ),
      ),
    );
  }

  _showSortMenu() {
    DialogUtils.show(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Sort'),
            ),
            Selector<RoutesProvider, HikingRouteSortable>(
              selector: (_, p) => p.sort,
              builder: (_, sort, __) => IntrinsicWidth(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: HikingRouteSortable.values
                      .map((e) => Button(
                            backgroundColor:
                                sort == e ? null : Color(0xFFF5F5F5),
                            child: Text(e.name,
                                style: sort == e
                                    ? null
                                    : TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color)),
                            onPressed: () {
                              context.read<RoutesProvider>().sort = e;
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Order'),
            ),
            Selector<RoutesProvider, Order>(
              selector: (_, p) => p.order,
              builder: (_, order, __) => Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: Order.values
                    .map((e) => Button(
                          backgroundColor:
                              order == e ? null : Color(0xFFF5F5F5),
                          child: Text(e.name,
                              style: order == e
                                  ? null
                                  : TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color)),
                          onPressed: () {
                            context.read<RoutesProvider>().order = e;
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ));
  }

  _showFilter() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (_) => RoutesFilter()));
  }
}
