import 'package:budgetiser/screens/transactions/transaction_form.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/widgets/smallStuff/balance_text.dart';
import 'package:flutter/material.dart';

/// Displays a transaction as widget
class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.singleTransactionData,
  }) : super(key: key);

  final SingleTransaction singleTransactionData;

  @override
  Widget build(BuildContext context) {
    String title;
    String description;
    double value;
    TransactionCategory category;
    Account account;
    Account? account2;
    DateTime date;

    title = singleTransactionData.title;
    description = singleTransactionData.description;
    value = singleTransactionData.value;
    category = singleTransactionData.category;
    account = singleTransactionData.account;
    account2 = singleTransactionData.account2;
    date = singleTransactionData.date;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TransactionForm(
              initialSingleTransactionData: singleTransactionData,
            ),
          ),
        )
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Row(
              //TODO: use common widget with transaction for vor visualisation of transaction (with arrows)
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                if (account2 == null)
                  Row(
                    children: [
                      Icon(
                        category.icon,
                        color: category.color,
                      ),
                      const Text(' in '),
                      Icon(
                        account.icon,
                        color: account.color,
                      ),
                    ],
                  ),
                if (account2 != null)
                  Row(
                    children: [
                      Icon(
                        category.icon,
                        color: category.color,
                      ),
                      const Text(' from '),
                      Icon(
                        account.icon,
                        color: account.color,
                      ),
                      const Text(' to '),
                      Icon(
                        account2.icon,
                        color: account2.color,
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.day}.${date.month}.${date.year}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textWidthBasis: TextWidthBasis.parent,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.merge(const TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
                BalanceText(value),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
