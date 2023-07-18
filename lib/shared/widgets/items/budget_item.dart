import 'package:budgetiser/screens/plans/budget_form.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/widgets/smallStuff/linear_progress_bar.dart';
import 'package:flutter/material.dart';

class BudgetItem extends StatelessWidget {
  const BudgetItem({
    Key? key,
    required this.budgetData,
  }) : super(key: key);
  final Budget budgetData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BudgetForm(
                  budgetData: budgetData,
                ),
              ),
            ),
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(
                            budgetData.icon,
                            color: budgetData.color,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(budgetData.name,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    budgetData.isRecurring
                        ? _getTimeInfos(
                            budgetData.startDate, budgetData.endDate!)
                        : (budgetData.startDate.compareTo(DateTime.now()) >= 0
                            ? Row(
                                children: [
                                  Text(
                                    'starts in: ${budgetData.startDate.difference(DateTime.now()).inDays}',
                                  ),
                                  const Icon(Icons.arrow_forward)
                                ],
                              )
                            : Container()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: LinearProgressBar(
                    percent: budgetData.balance / budgetData.limit,
                    color: budgetData.color,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      budgetData.balance.toString(),
                      style: TextStyle(
                        color: budgetData.balance > budgetData.limit
                            ? Colors.red
                            : Colors.white,
                      ),
                    ),
                    Text(budgetData.limit.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }

  Widget _getTimeInfos(DateTime start, DateTime end) {
    if (DateTime.now().compareTo(start) < 0) {
      return Row(
        children: [
          Text('starting in: ${start.difference(DateTime.now()).inDays}'),
          const Icon(Icons.arrow_forward)
        ],
      );
    } else if (DateTime.now().compareTo(end) > 0) {
      return Row(
        children: [
          Text('ended before: ${DateTime.now().difference(end).inDays}'),
          const Icon(Icons.arrow_back)
        ],
      );
    } else {
      return Row(
        children: [
          Text(
              "days left: ${(budgetData.calculateCurrentInterval()['end']!).difference(DateTime.now()).inDays}"),
          const Icon(Icons.repeat)
        ],
      );
    }
  }
}
