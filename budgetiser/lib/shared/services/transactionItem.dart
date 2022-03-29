import 'package:budgetiser/screens/transactions/editTransaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/services/balanceText.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  Transaction transactionData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          // onTap: () => {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => EditTransaction(
          //         initialIntervalMode: "Days",
          //         initialIsRecurring: isRecurring,
          //         initialNotes: notes,
          //         initialTitle: "title",
          //         initialValue: value,
          //       ),
          //     ),
          //   )
          // },
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
                    Text("Account: ${transactionData.account.name}"),
                    Text("Category: ${transactionData.category.name}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (transactionData is SingleTransaction)
                          Text(
                            "${(transactionData as SingleTransaction).date.day}/${(transactionData as SingleTransaction).date.month}/${(transactionData as SingleTransaction).date.year}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        if (transactionData is RecurringTransaction)
                          Text(
                            "${(transactionData as RecurringTransaction).startDate.day}/${(transactionData as RecurringTransaction).startDate.month}/${(transactionData as RecurringTransaction).startDate.year}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        const SizedBox(width: 10),
                        if (transactionData is RecurringTransaction)
                          Icon(
                            Icons.repeat,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                    if (transactionData.description != null)
                      Row(
                        children: [
                          Container(
                            child: Text(
                              transactionData.description,
                              overflow: TextOverflow.ellipsis,
                              textWidthBasis: TextWidthBasis.parent,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.merge(const TextStyle(fontSize: 18)),
                            ),
                            width: MediaQuery.of(context).size.width * 0.25,
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
