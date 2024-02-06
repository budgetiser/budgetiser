import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/statistics/screens/line_chart_stat/line_chart_stat_screen.dart';
import 'package:budgetiser/statistics/screens/text_stat/simple_text_stat_screen.dart';
import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});
  static String routeID = 'stats';

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      drawer: const CreateDrawer(),
      body: PageView(
        controller: _controller,
        children: const [
          LineChartStatScreen(),
          SimpleTextStatScreen(),
        ],
      ),
    );
  }
}
