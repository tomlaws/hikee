import 'package:flutter/material.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TrailInfo extends StatelessWidget {
  final Trail trail;
  final bool showTrailName;
  final bool hideRegion;
  const TrailInfo(
      {Key? key,
      required this.trail,
      this.showTrailName = false,
      this.hideRegion = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (showTrailName) ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              LineAwesomeIcons.map_signs,
              color: Colors.black45,
            ),
            Container(width: 8),
            Expanded(
              child: Text(
                trail.name_en,
                maxLines: 2,
                style: TextStyle(),
              ),
            ),
          ],
        ),
        Container(height: 8),
      ],
      if (!hideRegion) ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              LineAwesomeIcons.map,
              color: Colors.black45,
            ),
            Container(width: 8),
            Text(
              trail.region.name_en,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(),
            ),
          ],
        ),
        Container(height: 8),
      ],
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  LineAwesomeIcons.ruler,
                  color: Colors.black45,
                ),
                Container(width: 8),
                Text(
                  '${(trail.length / 1000).toString()}km',
                  style: TextStyle(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  LineAwesomeIcons.clock,
                  color: Colors.black45,
                ),
                Container(width: 8),
                Text(
                  TimeUtils.formatMinutes(trail.duration),
                  style: TextStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
