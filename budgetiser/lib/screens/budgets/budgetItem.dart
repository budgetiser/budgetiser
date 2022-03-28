import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BudgetItem extends StatelessWidget {
  final String name;
  final double currentValue;
  final double endValue;
  final MaterialColor color;
  const BudgetItem({
    Key? key, required this.name, required this.currentValue, required this.endValue, required this.color,
  }) : super(key: key);

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
                  children: [Text(name), Text("Noch 14 Tage")],
                ),
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 15.0,
                        percent: (currentValue/endValue),
                        backgroundColor: Colors.white,
                        linearGradient: LinearGradient(colors: createGradient(color)),
                        clipLinearGradient: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(currentValue.toString()),
                    Text(endValue.toString()),
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
    //gradient.add(baseColor.shade50);
    //gradient.add(baseColor.shade100);
    //gradient.add(baseColor.shade200);
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
