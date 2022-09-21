import 'package:budgetiser/screens/plans/budgetForm.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BudgetForm(
                      budgetData: budgetData,
                    ))),
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              //color: Theme.of(context).colorScheme.primary,
            ),
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            budgetData.icon,
                            color: budgetData.color,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(budgetData.name),
                        ],
                      ),
                      budgetData.isRecurring
                          ? _getTimeInfos(
                              budgetData.startDate, budgetData.endDate!)
                          : (budgetData.startDate.compareTo(DateTime.now()) >= 0
                              ? Row(
                                  children: [
                                    Text(
                                        "starts in: ${budgetData.startDate.difference(DateTime.now()).inDays}"),
                                    const Icon(Icons.arrow_forward)
                                  ],
                                )
                              : Container()),
                    ]),
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 15.0,
                        percent: getPercentInterval(
                            budgetData.balance, budgetData.limit),
                        backgroundColor: Colors.white,
                        linearGradient: LinearGradient(
                            colors: createGradient(budgetData.color)),
                        clipLinearGradient: true,
                      ),
                    ),
                  ],
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
          Text("starting in: ${start.difference(DateTime.now()).inDays}"),
          const Icon(Icons.arrow_forward)
        ],
      );
    } else if (DateTime.now().compareTo(end) > 0) {
      return Row(
        children: [
          Text("ended before: ${DateTime.now().difference(end).inDays}"),
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

  List<Color> createGradient(Color baseColor) {
    List<Color> gradient = [];
    gradient.add(
        Color.fromRGBO(baseColor.red, baseColor.green, baseColor.blue, 0.4));
    gradient.add(
        Color.fromRGBO(baseColor.red, baseColor.green, baseColor.blue, 0.5));
    gradient.add(
        Color.fromRGBO(baseColor.red, baseColor.green, baseColor.blue, 0.6));
    gradient.add(
        Color.fromRGBO(baseColor.red, baseColor.green, baseColor.blue, 0.7));
    gradient.add(
        Color.fromRGBO(baseColor.red, baseColor.green, baseColor.blue, 0.8));
    gradient.add(
        Color.fromRGBO(baseColor.red, baseColor.green, baseColor.blue, 0.9));
    gradient.add(
        Color.fromRGBO(baseColor.red, baseColor.green, baseColor.blue, 1.0));
    return gradient;
  }

  double getPercentInterval(double value, double base) {
    if (value >= base) {
      return 1.00;
    } else if (value <= 0) {
      return 0.00;
    } else {
      return value / base;
    }
  }
}
