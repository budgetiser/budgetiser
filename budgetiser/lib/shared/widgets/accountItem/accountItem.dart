import 'package:budgetiser/screens/account/accountForm.dart';
import 'package:budgetiser/screens/transactions/transactionForm.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/widgets/accountItem/accountItemTitle.dart';
import 'package:budgetiser/shared/widgets/smalStuff/balanceText.dart';
import 'package:flutter/material.dart';

class AccountItem extends StatelessWidget {
  final Account accountData;

  const AccountItem({
    Key? key,
    required this.accountData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AccountForm(
                  initialAccount: accountData,
                ),
              ),
            )
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
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
                      title: accountData.name,
                      icon: accountData.icon,
                      color: accountData.color,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => TransactionForm()),
                            );
                          },
                          child: const Icon(
                            Icons.arrow_upward,
                            size: 35,
                            color: Colors.green,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TransactionForm(
                                  initialNegative: true,
                                ),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.arrow_downward,
                            size: 35,
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
                        accountData.description,
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    BalanceText(accountData.balance),
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
}
