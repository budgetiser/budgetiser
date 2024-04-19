import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/statistics/screens/line_chart_stat/line_chart_stat_screen.dart';
import 'package:budgetiser/statistics/screens/stat_preview_widget.dart';
import 'package:budgetiser/statistics/screens/text_stat/simple_text_stat_screen.dart';
import 'package:flutter/material.dart';

class StatsOverview extends StatefulWidget {
  const StatsOverview({super.key});
  static String routeID = 'stats_overview';

  @override
  State<StatsOverview> createState() => _StatsOverviewState();
}

class _StatsOverviewState extends State<StatsOverview> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  // LineChartStatScreen(),
  // SimpleTextStatScreen(),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      drawer: const CreateDrawer(),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: [
          StatPreviewWidget(
            icon: Icons.line_axis_rounded,
            text: 'Line chart',
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LineChartStatScreen(),
                ),
              )
            },
          ),
          StatPreviewWidget(
            icon: Icons.abc,
            text: 'Text stat',
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SimpleTextStatScreen(),
                ),
              )
            },
          ),
        ],
      ),
    );
  }
}
