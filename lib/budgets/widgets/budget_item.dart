import 'package:budgetiser/budgets/screens/budget_form.dart';
import 'package:budgetiser/core/database/models/budget.dart';
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
    double percentage =
        budget.maxValue == 0 ? 0 : budget.value! / budget.maxValue;
    bool overflowed = percentage > 1;
    percentage -= percentage.floor();

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Row(
          children: [
            budgetIcon(),
            const SizedBox(width: 8),
            budgetDetails(overflowed, percentage, context),
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

  Padding budgetIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 8),
      child: Icon(
        budget.icon,
        color: budget.color,
      ),
    );
  }

  Expanded budgetDetails(
      bool overflowed, double percentage, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            budget.name,
            style: TextStyle(color: budget.color),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: budgetProgress(overflowed, percentage),
          ),
          budgetValues(overflowed, context),
        ],
      ),
    );
  }

  Widget budgetProgress(bool overflowed, double percentage) {
    return LinearProgressIndicator(
      value: overflowed ? 1 : percentage,
      borderRadius: BorderRadius.circular(8),
      color: budget.color,
    );
  }

  Widget budgetValues(bool overflowed, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          budget.value!.toStringAsFixed(1),
          style: TextStyle(
              color: overflowed ? Theme.of(context).colorScheme.error : null),
        ),
        Text(budget.maxValue.toStringAsFixed(1)),
      ],
    );
  }
}
