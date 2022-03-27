import 'package:budgetiser/shared/services/balanceText.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    Key? key,
    required this.account,
    required this.category,
    required this.date,
    required this.value,
    required this.isRecurring,
    this.notes,
  }) : super(key: key);

  int value;
  String account;
  String category;
  String? notes = "";
  bool isRecurring;
  DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => EditAccount(
            //       accountName: name,
            //       accountBalance: balance,
            //     ),
            //   ),
            // )
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
                    Text("Account $account"),
                    Text("Category $category"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${date.day}/${date.month}/${date.year}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(width: 10),
                        if (isRecurring)
                          Icon(
                            Icons.repeat,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                    if (notes != null)
                      Row(
                        children: [
                          Container(
                            child: Text(
                              notes!,
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
                    BalanceText(value),
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
