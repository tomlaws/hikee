import 'package:flutter/material.dart';
import 'package:hikee/data/routes.dart';
import 'package:hikee/models/route.dart';

class RouteScreen extends StatefulWidget {
  final int id;
  const RouteScreen({Key? key, required this.id}) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  @override
  Widget build(BuildContext context) {
    HikingRoute route = HikingRouteData.retrieve()[0];
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              backgroundColor: Colors.white,
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Image.network(
                    route.image,
                    fit: BoxFit.cover,
                  ))
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    route.name_en,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ]),
              ),
            )
          ],
        ));
  }
}
