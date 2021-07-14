import 'package:flutter/material.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class RouteInfo extends StatelessWidget {
  final HikingRoute route;
  const RouteInfo({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            LineAwesomeIcons.map_signs,
            color: Theme.of(context).primaryColor,
          ),
          Container(width: 8),
          Text(
            route.name_en,
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ],
      ),
      Container(height: 8),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            LineAwesomeIcons.ruler,
            color: Theme.of(context).primaryColor,
          ),
          Container(width: 8),
          Text(
            '${route.length.toString()}km',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ],
      ),
      Container(height: 8),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            LineAwesomeIcons.clock,
            color: Theme.of(context).primaryColor,
          ),
          Container(width: 8),
          Text(
            TimeUtils.toText(route.duration),
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ],
      ),
    ]);
  }
}
