import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/components/elevation_profile.dart';
import 'package:hikee/components/map.dart';
import 'package:hikee/pages/record/record_controller.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/time.dart';
import 'package:intl/intl.dart';

class RecordPage extends GetView<RecordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(title: Text('Record')),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: controller.obx((state) {
                  var decoded = GeoUtils.decodePath(state!.userPath);
                  return Container(
                    child: HikeeMap(path: decoded, pathOnly: true),
                  );
                }, onLoading: Shimmer()),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Trail',
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
                    )
                    // Container(
                    //     height: 160,
                    //     clipBehavior: Clip.antiAlias,
                    //     decoration:
                    //         BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
                    //     child: controller.obx((state) {
                    //       var p = GeoUtils.decodePath(state!.trail.path);
                    //       return HikeeMap(target: p.first, path: p);
                    //     },
                    //         onLoading: Shimmer(
                    //           height: 160,
                    //         )))

                    ,
                    controller.obx((state) {
                      if (state!.altitudes.length == 0) return SizedBox();
                      return Builder(builder: (context) {
                        return Container(
                          height: 160,
                          child: ElevationProfile(
                            elevations: state.altitudes,
                          ),
                        );
                      });
                    },
                        onLoading: Shimmer(
                          height: 160,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
