import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/models/current_location.dart';
import 'package:hikee/models/elevation.dart';
import 'package:hikee/services/route.dart';
import 'package:hikee/utils/geo.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class RouteElevation extends StatelessWidget {
  final int routeId;
  RouteElevation({Key? key, required this.routeId}) : super(key: key);

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  RouteService get routeService => GetIt.I<RouteService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Elevation>>(
        future: routeService.getElevations(routeId),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Consumer<CurrentLocation>(
              builder: (_, currentLocationProvider, __) {
            LatLng? _myLocation = currentLocationProvider.location;
            return _graph(snapshot.data!, myLocation: _myLocation);
          });
        });
  }

  Widget _graph(List<Elevation> elevations, {LatLng? myLocation}) {
    List<FlSpot> spots = [];
    double maxE = double.negativeInfinity;
    double minE = double.infinity;
    FlSpot? currentSpot;
    double minDist = double.infinity;
    elevations.asMap().forEach((index, value) {
      var dist = GeoUtils.calculateDistance(value.location, myLocation!);
      double e = value.elevation.roundToDouble();
      maxE = max(e, maxE);
      minE = min(e, minE);
      var spot = FlSpot(index.toDouble(), e);

      if (dist < minDist) {
        currentSpot = spot;
        minDist = dist;
      }
      return spots.add(spot);
    });
    if (minDist > 1) {
      // far away from route
    }
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: LineChart(LineChartData(
          gridData: FlGridData(
            show: false,
          ),
          borderData: FlBorderData(show: false),
          axisTitleData: FlAxisTitleData(
              show: true,
              leftTitle: AxisTitle(
                  showTitle: true,
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
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              interval: 100,
              reservedSize: 28,
              margin: 12,
            ),
          ),
          maxY: maxE + 48.0,
          minY: minE,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              colors: gradientColors,
              barWidth: 3,
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
                      show: true,
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
