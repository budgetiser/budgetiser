import 'package:budgetiser/accounts/screens/account_form.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/shared/widgets/balance_text.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon_with_text.dart';
import 'package:budgetiser/transactions/screens/transaction_form.dart';
import 'package:flutter/material.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({
    super.key,
    required this.accountData,
  });

  final Account accountData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AccountForm(
              initialAccount: accountData,
            ),
          ),
        ),
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        width: double.infinity,
        height: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SelectableIconWithText(
                    accountData,
                    size: 30,
                    coloredText: false,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TransactionForm(
                              initialSelectedAccount: accountData,
                              initialBalance: '',
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.arrow_upward,
                        semanticLabel: 'Deposit to ${accountData.name}',
                        size: 48,
                        color: Colors.green,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TransactionForm(
                              initialSelectedAccount: accountData,
                              initialBalance: '-',
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.arrow_downward,
                        semanticLabel: 'Withdraw from ${accountData.name}',
                        size: 48,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    accountData.description ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                BalanceText(accountData.balance),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
