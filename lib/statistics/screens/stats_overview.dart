import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/statistics/screens/account_bar_chart/account_bar_chart_screen.dart';
import 'package:budgetiser/statistics/screens/account_stat/simple_account_stat_screen.dart';
import 'package:budgetiser/statistics/screens/category_stat/simple_category_stat_screen.dart';
import 'package:budgetiser/statistics/screens/line_chart_stat/line_chart_stat_screen.dart';
import 'package:budgetiser/statistics/screens/stat_preview_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      drawer: const CreateDrawer(),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        crossAxisCount: 2,
        children: [
          StatPreviewWidget(
            text: 'Category stats',
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SimpleCategoryStatScreen(),
                ),
              ),
            },
            child: const Icon(
              Icons.category,
              size: 70,
            ),
          ),
          StatPreviewWidget(
            text: 'Account stats',
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SimpleAccountStatScreen(),
                ),
              ),
            },
            child: const Icon(
              Icons.account_balance,
              size: 70,
            ),
          ),
          StatPreviewWidget(
            text: 'Line chart',
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LineChartStatScreen(),
                ),
              ),
            },
            child: const Icon(
              Icons.line_axis_rounded,
              size: 70,
            ),
          ),
          StatPreviewWidget(
            text: 'Balance distribution',
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AccountBarChartScreen(),
                ),
              ),
            },
            child: const Icon(
              Icons.bar_chart,
              size: 70,
            ),
          ),
        ],
      ),
    );
  }
}
