import 'package:budgetiser/db/budget_provider.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/budgets/budget_form.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
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
            if (snapshot.hasData) {
              return _screenContent(snapshot.data!);
            }
            return const Center(child: CircularProgressIndicator());
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

  ListView _screenContent(List<Budget> budgets) {
    return ListView.builder(
      itemCount: budgets.length,
      itemBuilder: (context, i) {
        return Column(
          children: [
            BudgetItem(budget: budgets[i]),
            const Divider(
              indent: 8,
              endIndent: 8,
            )
          ],
        );
      },
    );
  }
}

class BudgetItem extends StatelessWidget {
  const BudgetItem({super.key, required this.budget});
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    budget.value ??= 0.0;
    double percentage = budget.value! / budget.maxValue;
    // TODO: double offset = percentage > 1
    //     ? 0.95
    //     : (percentage < 0.05 ? -0.95 : (-1 + (percentage * 2)) - 0.05);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    budget.name,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Icon(
                  budget.icon,
                  color: budget.color,
                ),
                //Text('${budget.maxValue}'),
              ],
            ),
            SizedBox(
              width: double.maxFinite,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: LinearProgressIndicator(
                      value: percentage,
                      color: budget.color,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Text(
                    '${(percentage * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          ],
        ),
        onTap: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BudgetForm(
                budgetData: budget,
              ),
            ),
          )
        },
      ),
    );
  }
}
