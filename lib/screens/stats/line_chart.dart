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
  double? max;
  double? min;
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
    List<Map<String, dynamic>> data,
  ) {
    data.sort((a, b) => a['date'].compareTo(b['date']));

    return LineChartBarData(
      spots: List.generate(data.length, (index) {
        double day = DateTime.parse(data[index]['date']).day.toDouble();
        double value = data[index]['value'].toDouble();
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
        child: FutureBuilder<Map<Account, List<Map<String, dynamic>>>>(
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
              max = null;
              min = null;

              for (MapEntry<Account, List<Map<String, dynamic>>> value
                  in snapshot.data!.entries) {
                List<Map<String, dynamic>> temp = value.value
                  ..sort((a, b) => a['value'].compareTo(b['value']));
                if (max == null || temp.last['value'] > max) {
                  max = temp.last['value'];
                }
                if (min == null || temp.first['value'] < min) {
                  min = temp.first['value'];
                }
              }

              if (max != null && max! < 0) {
                max = 0;
              }
              if (min != null && min! > 0) {
                min = 0;
              }

              double spread = max! - min!;
              print('returning');
              print(spread);
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
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 5,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (spread / 10).roundToDouble(),
                        // getTitlesWidget: leftTitleWidgets,
                        reservedSize: 70,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                    border: Border.all(color: const Color(0xff37434d)),
                  ),
                  minX: 1,
                  maxX: 31,
                  minY: min! - (spread.abs() * 0.1),
                  maxY: max! + (spread.abs() * 0.1),
                  lineBarsData: snapshot.data!.entries
                      .map((entry) => lineChartBarData(entry.key, entry.value))
                      .toList(),
                ),
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
