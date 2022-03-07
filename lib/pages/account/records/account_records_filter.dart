import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/bottom_bar.dart';
import 'package:hikees/components/core/check.dart';
import 'package:hikees/models/region.dart';
import 'package:hikees/pages/account/records/account_records_controller.dart';
import 'package:hikees/pages/trails/regions/central_nt.dart';
import 'package:hikees/pages/trails/regions/hong_kong_island.dart';
import 'package:hikees/pages/trails/regions/lantau.dart';
import 'package:hikees/pages/trails/regions/north_nt.dart';
import 'package:hikees/pages/trails/regions/others.dart';
import 'package:hikees/pages/trails/regions/sai_kung.dart';
import 'package:hikees/pages/trails/regions/west_nt.dart';
import 'package:hikees/pages/trails/trails_controller.dart';
import 'package:hikees/utils/time.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class AccountRecordsFilter extends StatefulWidget {
  const AccountRecordsFilter({Key? key, this.controller}) : super(key: key);

  @override
  _AccountRecordsFilterState createState() => _AccountRecordsFilterState();

  final AccountRecordsController? controller;
}

class _AccountRecordsFilterState extends State<AccountRecordsFilter> {
  var _regions = Rx<Set<int>>({});
  var _minDuration = Rx<int>(0);
  var _maxDuration = Rx<int>(0);
  var _minLength = Rx<int>(0);
  var _maxLength = Rx<int>(0);

  AccountRecordsController get controller {
    return widget.controller ??
        Get.find<AccountRecordsController>(tag: "search-records");
  }

  void apply() {
    controller.regions.assignAll(_regions.value);
    controller.minDuration = _minDuration.value;
    controller.maxDuration = _maxDuration.value;
    controller.minLength = _minLength.value;
    controller.maxLength = _maxLength.value;
    controller.refetch();
    Get.back();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _regions.value.assignAll(controller.regions);
    _minDuration.value = controller.minDuration;
    _maxDuration.value = controller.maxDuration;
    _minLength.value = controller.minLength;
    _maxLength.value = controller.maxLength;

    return Scaffold(
        appBar: HikeeAppBar(
          title: Text('filter'.tr),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('regions'.tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: Region.allRegions()
                              .map(
                                (r) => Obx(
                                  () => Check(
                                      label: r.name,
                                      checked: _regions.value.contains(r.id),
                                      onTap: (v) {
                                        toggleRegion(r.id);
                                      }),
                                ),
                              )
                              .toList(),
                        )),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Color(0xffc3e9e4),
                          borderRadius: BorderRadius.circular(16)),
                      child: _map(),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text('duration'.tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Obx(() => Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Text(TimeUtils.formatMinutes(
                                  _minDuration.value,
                                  hourOnly: true)),
                            ),
                            Expanded(
                              child: SfRangeSlider(
                                  min: 0,
                                  max: 10 * 60,
                                  values: SfRangeValues(
                                      _minDuration.value.toDouble(),
                                      _maxDuration.value.toDouble()),
                                  interval: 60,
                                  stepSize: 60,
                                  showLabels: false,
                                  enableTooltip: true,
                                  showTicks: false,
                                  onChanged: (SfRangeValues values) {
                                    _minDuration.value =
                                        (values.start as double).truncate();
                                    _maxDuration.value =
                                        (values.end as double).truncate();
                                  },
                                  tooltipTextFormatterCallback:
                                      (dynamic v, String s) {
                                    return TimeUtils.formatMinutes(
                                        (v as double).truncate(),
                                        hourOnly: true);
                                  }),
                            ),
                            SizedBox(
                              width: 40,
                              child: Text(TimeUtils.formatMinutes(
                                  _maxDuration.value,
                                  hourOnly: true)),
                            ),
                          ],
                        )),
                    Text('length'.tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Obx(() => Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Text(
                                  '${(_minLength / 1000).truncate().toString()}km'),
                            ),
                            Expanded(
                              child: SfRangeSlider(
                                  min: defaultMinLength,
                                  max: defaultMaxLength,
                                  values: SfRangeValues(
                                      _minLength.value.toDouble(),
                                      _maxLength.value.toDouble()),
                                  interval: 1000,
                                  stepSize: 1000,
                                  showLabels: false,
                                  enableTooltip: true,
                                  showTicks: false,
                                  onChanged: (SfRangeValues values) {
                                    _minLength.value =
                                        (values.start as double).truncate();
                                    _maxLength.value =
                                        (values.end as double).truncate();
                                  },
                                  tooltipTextFormatterCallback:
                                      (dynamic v, String s) {
                                    return '${((v as double) / 1000).truncate().toString()}km';
                                  }),
                            ),
                            SizedBox(
                              width: 40,
                              child: Text(
                                  '${(_maxLength.value / 1000).truncate().toString()}km'),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
            BottomBar(
                child: Row(
              children: [
                Expanded(
                    child: Button(
                        child: Text("apply".tr),
                        onPressed: () {
                          apply();
                        }))
              ],
            )),
          ],
        ));
  }

  void toggleRegion(int id) {
    _regions.value.contains(id)
        ? _regions.value.remove(id)
        : _regions.value.add(id);
    _regions.refresh();
  }

  Widget _map() {
    return AspectRatio(
        aspectRatio: 1.34256694,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                  onTap: () {
                    toggleRegion(5);
                  },
                  child: Obx(
                    () => CustomPaint(
                      painter: WestNT(
                          color: _regions.value.contains(5)
                              ? Colors.green
                              : Colors.green.withOpacity(.5)),
                    ),
                  )),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  toggleRegion(1);
                },
                child: Obx(
                  () => CustomPaint(
                    painter: NorthNT(
                        color: _regions.value.contains(1)
                            ? Colors.green
                            : Colors.green.withOpacity(.5)),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  toggleRegion(3);
                },
                child: Obx(
                  () => CustomPaint(
                    painter: CentralNT(
                        color: _regions.value.contains(3)
                            ? Colors.green
                            : Colors.green.withOpacity(.5)),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  toggleRegion(4);
                },
                child: Obx(
                  () => CustomPaint(
                    painter: SaiKung(
                        color: _regions.value.contains(4)
                            ? Colors.green
                            : Colors.green.withOpacity(.5)),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  toggleRegion(6);
                },
                child: Obx(
                  () => CustomPaint(
                    painter: Lantau(
                        color: _regions.value.contains(6)
                            ? Colors.green
                            : Colors.green.withOpacity(.5)),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  toggleRegion(2);
                },
                child: Obx(
                  () => CustomPaint(
                    painter: HongKongIsland(
                        color: _regions.value.contains(2)
                            ? Colors.green
                            : Colors.green.withOpacity(.5)),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  print('N/A');
                },
                child: CustomPaint(
                  painter: Others(),
                ),
              ),
            )
          ],
        ));
  }
}
