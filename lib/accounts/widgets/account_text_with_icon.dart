import 'package:budgetiser/core/database/models/account.dart';
import 'package:flutter/material.dart';

@Deprecated('Use selectable')
class AccountTextWithIcon extends StatelessWidget {
  const AccountTextWithIcon(
    this.account, {
    super.key,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          account.icon,
          color: account.color,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            account.name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
