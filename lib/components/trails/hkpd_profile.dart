import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/themes.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikees/models/hk_datum.dart';
import 'package:hikees/utils/geo.dart';

class HKPDProfile extends StatelessWidget {
  HKPDProfile({Key? key, required this.datums, this.myLocation, this.header})
      : super(key: key) {
    //assert(datums is List<HKDatum> || datums is List<int>);
  }

  final List<HKDatum> datums;
  final LatLng? myLocation;
  final Widget? header;
  final tooltipColor = Rx<Color>(Color(0xFFFFFFFFF));

  @override
  Widget build(BuildContext context) {
    if (datums.length == 0) {
      return Center(
        child: Opacity(opacity: .5, child: Text('heightsPending'.tr)),
      );
    }

    List<FlSpot> spots = [];
    double minX = 0.0;
    double length = 0.0; // max x
    double maxH = double.negativeInfinity;
    double minH = double.infinity;
    FlSpot? currentSpot;
    double minDist = double.infinity;

    datums.asMap().forEach((index, value) {
      // limits number of spot rendered, otherwise the line is not curvy enough
      //if (index % (datums.length / 32).round() == 0) {
      var dist = 9999.0;
      double e = 0;

      if (myLocation != null)
        dist = GeoUtils.calculateDistance(value.location, myLocation!);
      e = value.datum.toDouble();

      maxH = max(e, maxH);
      minH = min(e, minH);

      // update track length
      if (index > 0) {
        length += GeoUtils.calculateDistance(
                value.location, datums[index - 1].location) *
            1000;
      }
      var spot = FlSpot(length, e);

      if (dist < minDist) {
        currentSpot = spot;
        minDist = dist;
      }
      return spots.add(spot);
      //}
    });
    int interval = ((maxH - minH) / 6).round();
    if (interval == 0) {
      maxH += 10;
      minH -= 10;
      minH = max(0, minH);
      //   return Center(
      //     child: Opacity(opacity: .5, child: Text('heightsPending'.tr)),
      //   );
    }
    bool _showCurrent = true;
    if (minDist > 1) {
      // far away from trail
      _showCurrent = false;
    }
    int xInterval = 5; // 5meters
    if (length == 0) length = 1; // 1meters
    if (length >= 10000) {
      // > 10km
      xInterval = 5000;
    } else if (length >= 5000) {
      // >= 5km & < 10km
      xInterval = 2500;
    } else if (length >= 1000) {
      // >= 1km & < 5km
      xInterval = 500;
    } else if (length >= 500) {
      // >= 500m & < 1km
      xInterval = 250;
    } else if (length >= 100) {
      // >= 100m & < 500m
      xInterval = 50;
    }
    int yInterval = 5;
    double hSpan = maxH - minH;
    if (hSpan >= 500) {
      yInterval = 250;
    } else if (hSpan >= 250) {
      yInterval = 100;
    } else if (hSpan >= 100) {
      yInterval = 50;
    } else if (hSpan >= 50) {
      yInterval = 25;
    }
    var currentColor = getColorAtPercentage(Themes.gradientColors,
        spots.indexOf(currentSpot!) / spots.length.toDouble());
    return Column(children: [
      if (header != null) header!,
      Expanded(
          child: Obx(
        () => LineChart(LineChartData(
            gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (d) {
                  return FlLine(
                      color: Themes.gradientColors.first.withOpacity(.2),
                      strokeWidth: 1,
                      dashArray: [5]);
                },
                getDrawingVerticalLine: (d) {
                  return FlLine(
                      color: Themes.gradientColors.first.withOpacity(.2),
                      strokeWidth: 1,
                      dashArray: [5]);
                }),
            borderData: FlBorderData(show: false),
            axisTitleData: FlAxisTitleData(
                show: true,
                leftTitle: AxisTitle(
                    showTitle: false,
                    titleText: 'elevation'.tr,
                    textStyle: TextStyle(color: Colors.blueGrey))),
            titlesData: FlTitlesData(
              topTitles: SideTitles(showTitles: false),
              rightTitles: SideTitles(showTitles: false),
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (BuildContext context, double value) =>
                    TextStyle(
                  color: Color(0xff67727d),
                  fontSize: 11,
                ),
                interval: xInterval.toDouble(),
              ),
              leftTitles: SideTitles(
                  showTitles: true,
                  getTextStyles: (BuildContext context, double value) =>
                      TextStyle(
                          color: Color(0xff67727d),
                          fontSize: 11,
                          letterSpacing: -1),
                  interval: 1,
                  checkToShowTitle: (double minValue,
                      double maxValue,
                      SideTitles sideTitles,
                      double appliedInterval,
                      double value) {
                    if (value % yInterval == 0) return true;
                    return false;
                  }),
            ),
            minX: minX,
            maxX: length,
            maxY: maxH,
            minY: minH,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                //isCurved: true,
                colors: Themes.gradientColors,
                barWidth: 1,
                isStrokeCapRound: true,
                dotData: FlDotData(
                    show: _showCurrent,
                    checkToShowDot: (flSpot, lineChartBarData) {
                      return currentSpot == flSpot;
                    },
                    getDotPainter: (_, __, ___, i) {
                      FlDotPainter painter = FlDotCirclePainter(
                        radius: 4,
                        color: currentColor,
                        strokeColor: currentColor,
                        strokeWidth: 0,
                      );
                      return painter;
                    }),
                belowBarData: BarAreaData(
                    show: true,
                    colors: Themes.gradientColors
                        .map((color) => color.withOpacity(0.2))
                        .toList(),
                    spotsLine: currentSpot == null
                        ? null
                        : BarAreaSpotsLine(
                            show: _showCurrent,
                            flLineStyle:
                                FlLine(strokeWidth: 1, color: currentColor),
                            checkToShowSpotLine: (FlSpot spot) {
                              return spot == currentSpot;
                            })),
              ),
            ],
            lineTouchData: LineTouchData(
                touchCallback: (FlTouchEvent flTouchEvent,
                    LineTouchResponse? lineTouchResponse) {
                  var spotIndex =
                      lineTouchResponse?.lineBarSpots?.first.spotIndex;
                  if (spotIndex != null) {
                    tooltipColor.value = getColorAtPercentage(
                            Themes.gradientColors,
                            spotIndex / spots.length.toDouble()) ??
                        tooltipColor.value;
                  }
                },
                getTouchedSpotIndicator:
                    (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((spotIndex) {
                    //final spot = barData.spots[spotIndex];
                    var color = getColorAtPercentage(Themes.gradientColors,
                        spotIndex / spots.length.toDouble());
                    return TouchedSpotIndicatorData(
                      FlLine(color: color, strokeWidth: 1),
                      FlDotData(show: false),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: tooltipColor.value,
                    tooltipMargin: 5,
                    tooltipRoundedRadius: 6,
                    tooltipPadding: EdgeInsets.all(6.0),
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        return LineTooltipItem(
                          flSpot.y.toInt().toString() + 'm',
                          const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        );
                      }).toList();
                    })))),
      )),
    ]);
  }

  Color? getColorAtPercentage(List<Color> colors, double p) {
    var rgb = [
      round(colors[0].red + (colors[1].red - colors[0].red) * p),
      round(colors[0].green + (colors[1].green - colors[0].green) * p),
      round(colors[0].blue + (colors[1].blue - colors[0].blue) * p)
    ];
    return Color.fromARGB(255, rgb[0].toInt(), rgb[1].toInt(), rgb[2].toInt());
  }
}
