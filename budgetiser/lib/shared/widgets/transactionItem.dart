import 'package:budgetiser/screens/transactions/transactionForm.dart';
import 'package:budgetiser/shared/dataClasses/singleTransaction.dart';
import 'package:budgetiser/shared/widgets/balanceText.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  SingleTransaction transactionData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TransactionForm(
                  initialTransactionData: transactionData,
                ),
              ),
            )
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(transactionData.title),
                    if (transactionData.account2 == null)
                      Row(
                        children: [
                          Icon(
                            transactionData.category.icon,
                            color: transactionData.category.color,
                          ),
                          const Text(" in "),
                          Icon(
                            transactionData.account.icon,
                            color: transactionData.account.color,
                          ),
                        ],
                      ),
                    if (transactionData.account2 != null)
                      Row(
                        children: [
                          Icon(
                            transactionData.category.icon,
                            color: transactionData.category.color,
                          ),
                          const Text(" from "),
                          Icon(
                            transactionData.account.icon,
                            color: transactionData.account.color,
                          ),
                          const Text(" to "),
                          Icon(
                            transactionData.account2!.icon,
                            color: transactionData.account2!.color,
                          ),
                        ],
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${transactionData.date.day}.${transactionData.date.month}.${transactionData.date.year}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(width: 10),
                        if (false)
                          Icon(
                            Icons.repeat,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          transactionData.description,
                          overflow: TextOverflow.ellipsis,
                          textWidthBasis: TextWidthBasis.parent,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.merge(const TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    BalanceText(transactionData.value),
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
