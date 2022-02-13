import 'package:flutter/material.dart';
import 'package:hikee/models/active_trail.dart';
import 'package:hikee/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ActiveTrailInfo extends StatelessWidget {
  final ActiveTrail activeTrail;
  const ActiveTrailInfo({Key? key, required this.activeTrail})
      : super(key: key);

  String get name {
    return activeTrail.trail?.name_en ?? 'Unnamed';
  }

  int get length {
    return activeTrail.trail?.length ?? (activeTrail.length * 1000).round();
  }

  int get duration {
    return activeTrail.trail?.duration ?? (activeTrail.elapsed / 60).round();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
              name,
              maxLines: 2,
              style: TextStyle(),
            ),
          ),
        ],
      ),
      Container(height: 8),
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
                  '${(length / 1000).toString()}km',
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
                  TimeUtils.formatMinutes(duration),
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
