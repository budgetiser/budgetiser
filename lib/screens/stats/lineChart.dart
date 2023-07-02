import 'package:budgetiser/db/database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';

class LineChartTest extends StatefulWidget {
  const LineChartTest({
    Key? key,
    this.account,
  }) : super(key: key);
  final Account? account;
  @override
  State<LineChartTest> createState() => _LineChartTestState();
}

class _LineChartTestState extends State<LineChartTest>{

  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];


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
    if (value.toInt() % 250 == 0){
      text = value.toInt().toString();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseHelper.instance.getAccountBalancesAtTime(widget.account!, DateTime(2022, 10, 1), DateTime(2022, 10, 31)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Map<String, dynamic>> temp = snapshot.data!;
              if(snapshot.data!.isEmpty){
                return Text("No data");
              }
              temp.sort((a, b) => a['value'].compareTo(b['value']));
              return LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 1,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return const FlLine(
                          color: Colors.black,
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return const FlLine(
                          color: Colors.black,
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
                      show: true,
                      border: Border.all(color: const Color(0xff37434d)),
                    ),
                    minX: 0,
                    maxX: 32,
                    minY: temp.first["value"] > 0 ? temp.first["value"]-temp.first["value"]*0.05 : temp.first["value"]*1.05,
                    maxY: temp.last["value"] > 0 ? temp.last["value"]*1.05 : temp.last["value"]-temp.last["value"]*0.05,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(snapshot.data!.length, (index) {
                          double day = DateTime.parse(snapshot.data?[index]["date"]).day.toDouble();
                          double value = snapshot.data?[index]["value"].toDouble();
                          return FlSpot(day, value);
                        }),
                        isCurved: false,
                        gradient: LinearGradient(
                          colors: gradientColors,
                        ),
                        barWidth: 5,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.3))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  )
              );
            }
            else if (snapshot.hasError) {
              throw snapshot.error!;
            }
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )
      );
  }
}
