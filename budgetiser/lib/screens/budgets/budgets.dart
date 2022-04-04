import 'package:budgetiser/screens/budgets/budgetItem.dart';
import 'package:budgetiser/screens/budgets/newBudget.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
import 'package:flutter/material.dart';
import '../../shared/widgets/drawer.dart';

class Budgets extends StatelessWidget {
  static String routeID = 'budgets';

  const Budgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            children: [
              for (var budget in TMP_DATA_budgetList)
                BudgetItem(
                  budgetData: budget,
                ),
            ],
          ),
        );
  }
}
