import 'package:budgetiser/screens/account/editAccount.dart';
import 'package:budgetiser/shared/services/accountItem/accountItemTitle.dart';
import 'package:flutter/material.dart';

import '../balanceText.dart';

class AccountItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final int balance;

  const AccountItem(
    this.name,
    this.icon,
    this.balance, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditAccount(
                  accountName: name,
                  accountBalance: balance,
                ),
              ),
            )
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              // color: Theme.of(context).colorScheme.secondary,
            ),
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AccountItemTitle(
                      name,
                      icon,
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
                BalanceText(balance.toDouble()),
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
}
