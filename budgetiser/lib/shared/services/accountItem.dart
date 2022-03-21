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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.cyan[400],
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
                children: [
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
              Text(
                balance > 0 ? "+ $balance €" : "- ${0 - balance} €",
                style: const TextStyle(fontSize: 20),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
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
          style: const TextStyle(fontSize: 30),
        ),
      ),
    ],
  );
}
