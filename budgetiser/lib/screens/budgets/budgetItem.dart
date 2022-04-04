import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BudgetItem extends StatelessWidget {
  BudgetItem({
    Key? key,
    required this.budgetData,
  }) : super(key: key);
  Budget budgetData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => {},
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              //color: Theme.of(context).colorScheme.primary,
            ),
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(budgetData.name),
                      Row(
                        children: [
                          Text("days left: " + (budgetData.endDate).difference(DateTime.now()).inDays.toString()),
                          if (budgetData.isRecurring) Icon(Icons.repeat)
                        ],
                      )
                    ]),
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 15.0,
                        percent: (budgetData.balance / budgetData.limit),
                        backgroundColor: Colors.white,
                        linearGradient:
                            LinearGradient(colors: createGradient(budgetData.color)),
                        clipLinearGradient: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(budgetData.balance.toString()),
                    Text(budgetData.limit.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }

  List<Color> createGradient(MaterialColor baseColor) {
    List<Color> gradient = [];
    gradient.add(baseColor.shade300);
    gradient.add(baseColor.shade400);
    gradient.add(baseColor.shade500);
    gradient.add(baseColor.shade600);
    gradient.add(baseColor.shade700);
    gradient.add(baseColor.shade800);
    gradient.add(baseColor.shade900);
    return gradient;
  }
}
