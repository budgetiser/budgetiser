import 'package:budgetiser/budgets/screens/budget_form.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon.dart';
import 'package:flutter/material.dart';

class BudgetItem extends StatelessWidget {
  const BudgetItem({
    super.key,
    required this.budget,
  });
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    budget.value ??= 0.0;
    double percentage = budget.value! / budget.maxValue;
    // TODO: double offset = percentage > 1
    //     ? 0.95
    //     : (percentage < 0.05 ? -0.95 : (-1 + (percentage * 2)) - 0.05);
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    budget.name,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  budget.intervalUnit.label,
                ),
                const SizedBox(
                  width: 8,
                ),
                SelectableIcon(budget),
              ],
            ),
            const SizedBox(
              height: 4,
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
                  Text('${(percentage * 100).toStringAsFixed(1)}%'),
                ],
              ),
            )
          ],
        ),
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
    );
  }
}
