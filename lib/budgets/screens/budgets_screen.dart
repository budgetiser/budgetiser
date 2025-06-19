import 'package:budgetiser/budgets/screens/budget_form.dart';
import 'package:budgetiser/budgets/widgets/budget_item.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/provider/budget_provider.dart';
import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/shared/widgets/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({
    super.key,
  });
  static String routeID = 'budgets';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: const [],
      ),
      drawer: const CreateDrawer(),
      body: Consumer<BudgetModel>(
        builder: (context, model, child) {
          return FutureBuilder<List<Budget>>(
            future: model.getAllBudgets(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No Budgets'),
                );
              }
              if (snapshot.hasError) {
                return const Text('Oops!');
              }
              return _screenContent(snapshot.data!);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const BudgetForm(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          semanticLabel: 'create budget',
        ),
      ),
    );
  }

  Widget _screenContent(List<Budget> budgets) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GroupedListView<Budget, IntervalUnit>(
        elements: budgets,
        groupBy: (budget) => budget.intervalUnit,
        itemBuilder: (context, element) => BudgetItem(budget: element),
        groupSeparatorBuilder: (unit) => DividerWithText(unit.label),
        groupComparator: (value1, value2) =>
            Enum.compareByIndex(value1, value2),
      ),
    );
  }
}
