import 'package:budgetiser/accounts/widgets/account_items_widget.dart';
import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/statistics/screens/stat_preview_widget.dart';
import 'package:budgetiser/statistics/screens/text_stat/simple_text_stat_screen.dart';
import 'package:budgetiser/transactions/screens/transaction_form.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });
  static String routeID = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const CreateDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card.filled(
              child: AccountItemsWidget(),
            ),
          ),
          Expanded(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                StatPreviewWidget(
                  text: 'Text stat',
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SimpleTextStatScreen(),
                      ),
                    )
                  },
                  child: const Icon(
                    Icons.abc,
                    size: 70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TransactionForm(),
            ),
          );
        },
        label: const Text('new Transaction'),
        icon: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
