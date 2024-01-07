import 'package:budgetiser/db/budget_provider.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/budgets/budget_form.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/widgets/itemLists/item_list_container.dart';
import 'package:budgetiser/shared/widgets/items/budget_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatelessWidget {
  static String routeID = 'budgets';
  const BudgetScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: const [],
      ),
      drawer: const CreateDrawer(),
      body: Consumer<BudgetModel>(builder: (context, value, child) {
        return FutureBuilder<List<Budget>>(
          future: BudgetModel().getAllBudgets(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return _screenContent(snapshot.data!);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const BudgetForm(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _screenContent(List<Budget> budgets) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 80),
      separatorBuilder: (context, index) => const ItemListDivider(),
      itemCount: budgets.length,
      itemBuilder: (context, i) {
        return BudgetItem(budget: budgets[i]);
      },
    );
  }
}
