import 'package:flutter/material.dart';

class AccountItem extends StatelessWidget {
  String name;
  IconData icon;
  int balance;

  AccountItem(this.name, this.icon, this.balance, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(20)),
        color: Theme.of(context).colorScheme.primary,
      ),
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AccountItemTitle(
                context,
                icon,
                name,
              ),
              Row(
                children: const [
                  Icon(
                    Icons.arrow_upward,
                    size: 35,
                  ),
                  Icon(
                    Icons.arrow_downward,
                    size: 35,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              if (balance > 0) ...[
                Text(
                  "+ $balance €",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: const Color.fromARGB(239, 29, 129, 37),
                      ),
                ),
              ] else ...[
                Text(
                  "- ${0 - balance} €",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: const Color.fromARGB(238, 129, 29, 29),
                      ),
                ),
              ]
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ],
      ),
    );
  }
}

Widget AccountItemTitle(BuildContext context, IconData icon, String name) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(
        icon,
        size: 30,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          name,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    ],
  );
}
