import 'package:budgetiser/accounts/widgets/balance_text.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:budgetiser/transactions/screens/transaction_form.dart';
import 'package:budgetiser/transactions/widgets/visualize_transaction_small.dart';
import 'package:flutter/material.dart';

/// Displays a transaction as widget
class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transactionData,
  });

  final SingleTransaction transactionData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TransactionForm(
              initialSingleTransactionData: transactionData,
            ),
          ),
        )
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            // top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    transactionData.title,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TransactionVisualization(transaction: transactionData),
              ],
            ),
            const SizedBox(height: 8),
            // second/bottom row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateAsDDMMYYYY(transactionData.date),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      transactionData.description ?? '',
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
                BalanceText(
                  transactionData.value,
                  isColored: transactionData.account2 == null,
                  hasPrefix: transactionData.account2 == null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
