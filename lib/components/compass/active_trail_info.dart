import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/text_may_overflow.dart';
import 'package:hikees/models/active_trail.dart';
import 'package:hikees/themes.dart';
import 'package:hikees/utils/time.dart';
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
    return activeTrail.name ?? activeTrail.trail?.name ?? 'unnamed'.tr;
  }

  int get length {
    if (activeTrail.trail == null) {
      return activeTrail.length;
    }
    return activeTrail.trail?.length ?? 0;
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
            Icons.location_pin,
            color: Themes.gradientColors.first,
            size: 16,
          ),
          Container(width: 8),
          Expanded(
            child: Row(children: [
              Expanded(
                child: Opacity(
                  opacity: named ? 1 : .5,
                  child: TextMayOverflow(
                    name,
                  ),
                ),
              ),
              Material(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6.0),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {
                    onEdit();
                  },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4.0,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 12,
                            color: Colors.black45,
                          ),
                          Text(
                            'edit'.tr,
                            style: TextStyle(fontSize: 13),
                          )
                        ],
                      )),
                ),
              ),
            ]),
          ),
        ],
      ),
    ]);
  }
}
