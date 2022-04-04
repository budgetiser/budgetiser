import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SavingItem extends StatelessWidget {
  SavingItem({Key? key, required this.savingData}) : super(key: key);
  Savings savingData;

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
                    children: [Text(savingData.name), Text("days left: " + (savingData.endDate).difference(DateTime.now()).inDays.toString())]
                ),
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 15.0,
                        percent: (savingData.balance/savingData.goal),
                        backgroundColor: Colors.white,
                        linearGradient: LinearGradient(colors: createGradient(savingData.color)),
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
        Divider(
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }

  List<Color> createGradient(MaterialColor baseColor){
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
