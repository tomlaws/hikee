import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/components/map/map.dart';
import 'package:hikees/pages/record/record_controller.dart';
import 'package:hikees/utils/geo.dart';
import 'package:hikees/utils/time.dart';
import 'package:intl/intl.dart';

class RecordPage extends GetView<RecordController> {
  @override
  Widget build(BuildContext context) {
    var bottomPanelHeight = 220.0;
    return Scaffold(
      appBar: HikeeAppBar(
        title: Text('record'.tr),
        actions: [
          if (!controller.offline)
            Button(
                icon: Icon(Icons.upload),
                invert: true,
                onPressed: () {
                  if (controller.state == null) {
                    return;
                  }
                  var record = controller.state!;
                  Get.toNamed('/trails/create', arguments: {
                    'path': record.userPath,
                    'name': record.name,
                    'region': record.region
                  });
                })
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            top: 0.0,
            bottom: bottomPanelHeight -
                18.0 +
                MediaQuery.of(context).viewPadding.bottom,
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
                      Text('trail'.tr,
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
                          onLoading: Shimmer(
                            width: 80,
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('date'.tr,
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('time'.tr,
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
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('region'.tr,
                                    style: TextStyle(
                                      color: Colors.black38,
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                controller.obx(
                                    (state) =>
                                        Text(state!.region?.name ?? 'N/A'),
                                    onLoading: Shimmer()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('distance'.tr,
                                    style: TextStyle(
                                      color: Colors.black38,
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                controller.obx(
                                    (state) => Text(
                                          GeoUtils.formatMetres(
                                              GeoUtils.getPathLength(
                                                  encodedPath:
                                                      state!.userPath)),
                                          style: TextStyle(),
                                        ),
                                    onLoading: Shimmer()),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('timeUsed'.tr,
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
                            ),
                          ),
                          Expanded(child: SizedBox())
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
