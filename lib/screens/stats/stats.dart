import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/stats/line_chart_stat/line_chart_stat_screen.dart';
import 'package:budgetiser/screens/stats/text_stat/simple_text_stat_screen.dart';
import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  static String routeID = 'stats';
  const Stats({Key? key}) : super(key: key);

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
