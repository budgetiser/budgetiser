import 'package:budgetiser/db/database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';

class LineChartTest extends StatefulWidget {
  const LineChartTest({
    Key? key,
    required this.accounts,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);
  final List<Account> accounts;
  final DateTime startDate;
  final DateTime endDate;
  @override
  State<LineChartTest> createState() => _LineChartTestState();
}

class _LineChartTestState extends State<LineChartTest> {
  double? max;
  double? min;
  double? spread;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 30:
        text = const Text('30', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = "";
    if (spread != null && value.toInt() % (spread! / 4) == 0) {
      text = value.toInt().toString();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartBarData lineChartBarData(Account acc, data) {
    return LineChartBarData(
      spots: List.generate(data.length, (index) {
        double day = DateTime.parse(data[index]["date"]).day.toDouble();
        double value = data[index]["value"].toDouble();
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
    spread = null;
    max = null;
    min = null;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: FutureBuilder<Map<Account, List<Map<String, dynamic>>>>(
          future: DatabaseHelper.instance.getAccountBalancesAtTime(
              widget.accounts, widget.startDate, widget.endDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data!.isEmpty) {
                return const Text("No data");
              }

              snapshot.data!.forEach(
                (key, value) {
                  List<Map<String, dynamic>> temp = value;
                  temp.sort((a, b) => a['value'].compareTo(b['value']));
                  if (max == null || temp.last["value"] > max) {
                    max = temp.last["value"];
                  }
                  if (min == null || temp.first["value"] < min) {
                    min = temp.first["value"];
                  }
                },
              );

              spread = (max! - min!);
              return LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: spread! / 4,
                    verticalInterval: 10,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
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
                        interval: 1,
                        getTitlesWidget: bottomTitleWidgets,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: leftTitleWidgets,
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                    border: Border.all(color: const Color(0xff37434d)),
                  ),
                  minX: 1,
                  maxX: 31,
                  minY: min! -
                      (spread!.abs() *
                          0.1), //temp.first["value"] > 0 ? temp.first["value"]-temp.first["value"]*0.05 : temp.first["value"]*1.05,
                  maxY: max! +
                      (spread!.abs() *
                          0.1), //temp.last["value"] > 0 ? temp.last["value"]*1.05 : temp.last["value"]-temp.last["value"]*0.05,
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
