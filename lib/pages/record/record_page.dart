import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/components/elevation_profile.dart';
import 'package:hikee/components/map/map.dart';
import 'package:hikee/pages/record/record_controller.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/time.dart';
import 'package:intl/intl.dart';

class RecordPage extends GetView<RecordController> {
  @override
  Widget build(BuildContext context) {
    var bottomPanelHeight = 200.0;
    return Scaffold(
      appBar: HikeeAppBar(title: Text('Record')),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: bottomPanelHeight - 18.0,
            child: controller.obx((state) {
              var decoded = GeoUtils.decodePath(state!.userPath);
              var referencePath = state.referenceTrail != null
                  ? GeoUtils.decodePath(state.referenceTrail!.path)
                  : null;
              return Container(
                child: HikeeMap(
                  path: referencePath,
                  userPath: decoded,
                  pathOnly: true,
                  contentMargin: EdgeInsets.only(
                      left: 8, bottom: 8 + 18, right: 8, top: 8),
                ),
              );
            }, onLoading: Shimmer()),
          ),
          Positioned.fill(
            top: null,
            child: SafeArea(
              child: Container(
                height: bottomPanelHeight,
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(26))),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trail',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black38,
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      controller.obx(
                          (state) => Text(
                                state!.name,
                                style: TextStyle(),
                              ),
                          onLoading: Shimmer()),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date',
                                    style: TextStyle(
                                      color: Colors.black38,
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                controller.obx(
                                    (state) => Text(
                                          DateFormat('yyyy-MM-dd')
                                              .format(state!.date),
                                          style: TextStyle(),
                                        ),
                                    onLoading: Shimmer()),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 32,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time',
                                  style: TextStyle(
                                    color: Colors.black38,
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              controller.obx(
                                  (state) => Text(
                                        DateFormat('HH:mm:ss')
                                            .format(state!.date),
                                        style: TextStyle(),
                                      ),
                                  onLoading: Shimmer()),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Distance',
                                    style: TextStyle(
                                      color: Colors.black38,
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                controller.obx(
                                    (state) => Text(
                                          '${(GeoUtils.getPathLength(encodedPath: state!.userPath)).toString()}km',
                                          style: TextStyle(),
                                        ),
                                    onLoading: Shimmer()),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 32,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time Used',
                                  style: TextStyle(
                                    color: Colors.black38,
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              controller.obx(
                                  (state) => Text(
                                        TimeUtils.formatSeconds(state!.time),
                                        style: TextStyle(),
                                      ),
                                  onLoading: Shimmer()),
                            ],
                          )
                        ],
                      ),
                      // controller.obx((state) {
                      //   if (state!.altitudes.length == 0) return SizedBox();
                      //   return Builder(builder: (context) {
                      //     return Container(
                      //       height: 160,
                      //       child: ElevationProfile(
                      //         elevations: state.altitudes,
                      //       ),
                      //     );
                      //   });
                      // },
                      //     onLoading: Shimmer(
                      //       height: 160,
                      //     )),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
