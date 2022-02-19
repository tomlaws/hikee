import 'package:flutter/material.dart';
import 'package:hikee/models/active_trail.dart';
import 'package:hikee/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ActiveTrailInfo extends StatelessWidget {
  final ActiveTrail activeTrail;
  final void Function() onEdit;
  const ActiveTrailInfo(
      {Key? key, required this.activeTrail, required this.onEdit})
      : super(key: key);

  bool get named {
    if (activeTrail.trail != null) return true;
    return activeTrail.name != null;
  }

  String get name {
    return activeTrail.name ?? activeTrail.trail?.name_en ?? 'Unnamed';
  }

  double get length {
    if (activeTrail.trail == null) {
      return activeTrail.length;
    }
    return ((activeTrail.trail?.length ?? 0) / 1000);
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
            child: Row(children: [
              Opacity(
                opacity: named ? 1 : .5,
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      onEdit();
                    },
                    child: Icon(
                      LineAwesomeIcons.edit,
                      color: Colors.black45,
                    ),
                  )),
            ]),
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
                  '${(length).toString()}km',
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
