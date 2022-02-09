import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikee/models/elevation.dart';
import 'package:hikee/utils/geo.dart';

class ElevationProfile extends StatelessWidget {
  ElevationProfile({Key? key, required this.elevations, this.myLocation})
      : super(key: key) {
    assert(elevations is List<Elevation> || elevations is List<double>);
  }

  final dynamic elevations;
  final LatLng? myLocation;

  @override
  Widget build(BuildContext context) {
    if (elevations.length == 0) {
      return Center(
        child: Text('No data'),
      );
    }
    final List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];
    List<FlSpot> spots = [];
    double maxE = double.negativeInfinity;
    double minE = double.infinity;
    FlSpot? currentSpot;
    double minDist = double.infinity;
    elevations.asMap().forEach((index, value) {
      // limits number of spot rendered, otherwise the line is not curvy enough
      if (index % (elevations.length / 32).round() == 0) {
        var dist = 0.0;
        double e = 0;
        if (value is Elevation) {
          if (myLocation != null)
            dist = GeoUtils.calculateDistance(value.location, myLocation!);
          e = value.elevation.roundToDouble();
        }
        if (value is double) {
          e = value;
        }
        maxE = max(e, maxE);
        minE = min(e, minE);
        var spot = FlSpot(index.toDouble(), e);

        if (dist < minDist) {
          currentSpot = spot;
          minDist = dist;
        }
        return spots.add(spot);
      }
    });
    int interval = ((maxE - minE) / 6).round();
    if (interval == 0) {
      return Center(
        child: Text('No data'),
      );
    }
    bool _showCurrent = true;
    if (minDist > 1) {
      // far away from trail
      _showCurrent = false;
    }
    return Container(
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
            topTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(
              showTitles: false,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (BuildContext context, double value) => TextStyle(
                color: Color(0xff67727d),
                fontSize: 12,
              ),
              interval: interval.toDouble(),
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
                  spotsLine: currentSpot == null
                      ? null
                      : BarAreaSpotsLine(
                          show: _showCurrent,
                          flLineStyle: FlLine(
                              strokeWidth: 1,
                              color: lerpGradient(
                                  gradientColors,
                                  [0, 1],
                                  spots.indexOf(currentSpot!) /
                                      spots.length.toDouble())),
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

  Color? lerpGradient(List<Color> colors, List<double> stops, double t) {
    for (int s = 0; s < stops.length - 1; s++) {
      final leftStop = stops[s], rightStop = stops[s + 1];
      final leftColor = colors[s], rightColor = colors[s + 1];
      if (t <= leftStop) {
        return leftColor;
      } else if (t < rightStop) {
        final sectionT = (t - leftStop) / (rightStop - leftStop);
        return Color.lerp(leftColor, rightColor, sectionT);
      }
    }
    return colors.last;
  }
}
