import 'package:flutter/material.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/data/routes.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/route.dart';
import 'package:provider/provider.dart';

class RouteScreen extends StatefulWidget {
  final int id;
  const RouteScreen({Key? key, required this.id}) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  @override
  Widget build(BuildContext context) {
    HikingRoute route = HikingRouteData.retrieve()
        .firstWhere((element) => element.id == widget.id);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              route.name_en,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              route.district_en,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFFBBBBBB)),
                            ),
                          ],
                        ),
                      ),
                      Button(
                        onPressed: () {
                          Provider.of<ActiveHikingRoute>(context, listen: false)
                              .update(route);
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        },
                        child: Text('GO NOW'),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      route.description_en,
                      style: TextStyle(),
                    ),
                  ),
                ]),
              ),
            )
          ],
        ));
  }
}
