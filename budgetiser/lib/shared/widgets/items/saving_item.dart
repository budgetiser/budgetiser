import 'package:budgetiser/screens/plans/saving_form.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SavingItem extends StatelessWidget {
  const SavingItem({
    Key? key,
    required this.savingData,
  }) : super(key: key);

  final Savings savingData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SavingForm(
                      savingData: savingData,
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
                            savingData.icon,
                            color: savingData.color,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(savingData.name),
                        ],
                      ),
                      Text(
                          "days left: ${(savingData.endDate).difference(DateTime.now()).inDays}")
                    ]),
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 15.0,
                        percent: (savingData.balance / savingData.goal),
                        backgroundColor: Colors.white,
                        linearGradient: LinearGradient(
                            colors: createGradient(savingData.color)),
                        clipLinearGradient: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(savingData.balance.toString()),
                    Text(savingData.goal.toString()),
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
}
