import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/data/routes.dart';
import 'package:hikee/screens/route.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text("Hiking Library", textAlign: TextAlign.left, style: TextStyle(fontSize: 20)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextInput(
                    hintText: 'Search...',
                  ),
                ),
                Expanded(
                    child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              // The builder function returns a ListTile with a title that
                              // displays the index of the current item.
                              (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: HikingRouteTile(
                                    route: HikingRouteData.retrieve()[index],
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (_) => RouteScreen(
                                              id: HikingRouteData.retrieve()[index].id)));
                                    }),
                              ),
                              // Builds 1000 ListTiles
                              childCount: HikingRouteData.retrieve().length,
                            ),
                          )
                        ]
                    )
                ),

              ]),
        ),
      ),
    );
  }
}

