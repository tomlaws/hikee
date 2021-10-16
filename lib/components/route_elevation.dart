import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/models/elevation.dart';
import 'package:hikee/pages/compass/compass_controller.dart';
import 'package:hikee/providers/route.dart';
import 'package:hikee/utils/geo.dart';

class RouteElevationController extends GetxController
    with StateMixin<List<Elevation>> {}

class RouteElevation extends GetView<RouteElevationController> {
  final RouteElevationController controller =
      Get.put(RouteElevationController());
  final RouteProvider _routeProvider = Get.put(RouteProvider());
  final CompassController _compassController = Get.put(CompassController());

  final int routeId;

  RouteElevation({Key? key, required this.routeId}) : super(key: key) {
    controller.append(() => () => _routeProvider.getElevations(routeId));
  }

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return controller.obx((state) {
      LatLng? _myLocation = _compassController.currentLocation.value;
      return _graph(state!, myLocation: _myLocation);
    },
        onLoading: Center(
          child: CircularProgressIndicator(),
        ));
  }

  Widget _graph(List<Elevation> elevations, {LatLng? myLocation}) {
    List<FlSpot> spots = [];
    double maxE = double.negativeInfinity;
    double minE = double.infinity;
    FlSpot? currentSpot;
    double minDist = double.infinity;
    elevations.asMap().forEach((index, value) {
      var dist = 0.0;
      if (myLocation != null)
        dist = GeoUtils.calculateDistance(value.location, myLocation);
      double e = value.elevation.roundToDouble();
      maxE = max(e, maxE);
      minE = min(e, minE);
      var spot = FlSpot(index.toDouble(), e);

      if (dist < minDist) {
        currentSpot = spot;
        minDist = dist;
      }
      // limits number of spot rendered, otherwise the line is not curvy enough
      if (index % (elevations.length / 32).round() == 0) return spots.add(spot);
    });
    int interval = ((maxE - minE) / 6).round();
    bool _showCurrent = true;
    if (minDist > 1) {
      // far away from route
      _showCurrent = false;
    }
    return Container(
      //margin: EdgeInsets.only(left: 8, right: 16, top: 16, bottom: 16),
      child: LineChart(LineChartData(
          gridData: FlGridData(
            show: false,
          ),
          borderData: FlBorderData(show: false),
          axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                  showTitle: false,
                  titleText: 'Elevation',
                  textStyle: TextStyle(color: Colors.blueGrey))),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: false,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(
                color: Color(0xff67727d),
                fontSize: 12,
              ),
              interval: interval.toDouble(),
              //reservedSize: 24,
              //margin: 6,
            ),
          ),
          maxY: maxE,
          minY: minE,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              colors: gradientColors,
              barWidth: 1,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                  show: true,
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.2))
                      .toList(),
                  spotsLine: BarAreaSpotsLine(
                      show: _showCurrent,
                      flLineStyle: FlLine(color: Colors.blue),
                      checkToShowSpotLine: (FlSpot spot) {
                        return spot == currentSpot;
                      })),
            ),
          ],
          lineTouchData: LineTouchData(enabled: false)
          // lineTouchData: LineTouchData(
          //     getTouchedSpotIndicator:
          //         (LineChartBarData barData, List<int> spotIndexes) {
          //       return spotIndexes.map((spotIndex) {
          //         //final spot = barData.spots[spotIndex];
          //         return TouchedSpotIndicatorData(
          //           FlLine(color: Color(0xFF5DB075), strokeWidth: 2),
          //           FlDotData(show: false),
          //         );
          //       }).toList();
          //     },
          //     touchTooltipData: LineTouchTooltipData(
          //         tooltipBgColor: Color(0xFF5DB075),
          //         tooltipMargin: 1,
          //         tooltipRoundedRadius: 3,
          //         getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
          //           return touchedBarSpots.map((barSpot) {
          //             final flSpot = barSpot;
          //             return LineTooltipItem(
          //               flSpot.y.toString(),
          //               const TextStyle(
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             );
          //           }).toList();
          //         }))
          )),
    );
  }
}
