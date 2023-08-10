import 'dart:math';

import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartAccounts extends StatefulWidget {
  const LineChartAccounts({
    Key? key,
    required this.accounts,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);
  final List<Account> accounts;
  final DateTime startDate;
  final DateTime endDate;
  @override
  State<LineChartAccounts> createState() => _LineChartAccountsState();
}

class _LineChartAccountsState extends State<LineChartAccounts> {
  double? maxValue;
  double? minValue;
  double? spread;

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = '';
    if (spread != null && value.toInt() % (spread! / 4) == 0) {
      text = value.toInt().toString();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartBarData lineChartBarData(
    Account acc,
    List<Map<DateTime, double>> data,
  ) {
    data.sort((a, b) => a.keys.first.compareTo(b.keys.first));

    return LineChartBarData(
      spots: List.generate(data.length, (index) {
        double day = data[index].keys.first.day.toDouble();
        double value = data[index].values.first;
        return FlSpot(day, value);
      }),
      isCurved: false,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: const FlDotData(
        show: false,
      ),
      color: acc.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: FutureBuilder<Map<Account, List<Map<DateTime, double>>>>(
          future: DatabaseHelper.instance.getAccountBalancesAtTime(
            widget.accounts,
            widget.startDate,
            widget.endDate,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Text('No data');
              }
              maxValue = null;
              minValue = null;

              for (MapEntry<Account, List<Map<DateTime, double>>> value
                  in snapshot.data!.entries) {
                for (Map<DateTime, double> innerValue in value.value) {
                  if (maxValue == null || innerValue.values.first > maxValue!) {
                    maxValue = innerValue.values.first;
                  }
                  if (minValue == null || innerValue.values.first < minValue!) {
                    minValue = innerValue.values.first;
                  }
                }
              }

              if (maxValue != null && maxValue! < 0) {
                maxValue = 0;
              }
              if (minValue != null && minValue! > 0) {
                minValue = 0;
              }

              double spread = max(maxValue! - minValue!, 1);
              return LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    verticalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max) {
                            return Container();
                          }
                          return Text(meta.formattedValue);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: max((spread / 10).roundToDouble(), 1),
                        reservedSize: 70,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max || value == meta.min) {
                            return Container();
                          }
                          return Text(meta.formattedValue);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                    border: Border.all(color: const Color(0xff37434d)),
                  ),
                  minX: 1,
                  maxX: 31,
                  minY: minValue! - spread * 0.1,
                  maxY: maxValue! + spread * 0.1,
                  lineBarsData: snapshot.data!.entries
                      .map((entry) => lineChartBarData(entry.key, entry.value))
                      .toList(),
                ),
                duration: Duration.zero,
              );
            } else if (snapshot.hasError) {
              throw snapshot.error!;
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
