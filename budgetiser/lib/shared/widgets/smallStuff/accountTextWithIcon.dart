import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:flutter/material.dart';

class AccountTextWithIcon extends StatelessWidget {
  const AccountTextWithIcon(
    this.account, {
    Key? key,
  }) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        account.icon,
        color: account.color,
      ),
      Flexible(
        child: Text(" " + account.name, overflow: TextOverflow.ellipsis),
      ),
    ]);
  }
}
