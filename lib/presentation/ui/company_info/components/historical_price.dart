import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/models/models.dart';

import '../../../models/models.dart';
import '../../../protocols/protocols.dart';

class HistoricalPrice extends GetView<CompanyInfoPresenter> {
  HistoricalPrice({Key? key}) : super(key: key);

  final scrollController = ScrollController();

  LineChartData _chartData(List<HistoricalStockPriceViewModel> data) {
    List<Color> gradientColors = [
      const Color(0xff23b6e6),
      const Color(0xff02d39a),
    ];

    double counter = -5.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      lineTouchData: LineTouchData(
        enabled: true,
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: Colors.pink,
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 8,
                  strokeWidth: 2,
                  strokeColor: Colors.black,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.pink,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
            return lineBarsSpot.map((lineBarSpot) {
              final index = lineBarSpot.y ~/ 5;
              return LineTooltipItem(
                '${lineBarSpot.y}\n${data[index].date}\n${data[index].hour}',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: data.map((e) {
            counter += 5.0;
            return FlSpot(counter, e.price);
          }).toList(),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0, bottom: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder<List<HistoricalStockPriceViewModel>>(
                    stream: controller.historicalPriceStream,
                    initialData: <HistoricalStockPriceViewModel>[],
                    builder: (context, snapshot) {
                      return Container(
                        width: max((snapshot.data?.length ?? 0) * 5, MediaQuery.of(context).size.shortestSide - 16.0),
                        child: LineChart(
                          _chartData(snapshot.data ?? []),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
        StreamBuilder<PriceInterval>(
          stream: controller.priceIntervalStream,
          initialData: PriceInterval.oneHour,
          builder: (context, snapshot) {
            return Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final priceInterval in PriceInterval.values) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: snapshot.data == priceInterval
                        ? OutlinedButton(
                            onPressed: () => controller.priceInterval = priceInterval,
                            child: Text(priceInterval.description),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 1.0, color: Colors.blue),
                            ))
                        : ElevatedButton(
                            onPressed: () => controller.priceInterval = priceInterval,
                            child: Text(priceInterval.description),
                          ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
