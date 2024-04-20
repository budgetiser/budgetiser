import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/shared/widgets/balance_text.dart';
import 'package:flutter/material.dart';

class SimpleTextStat extends StatelessWidget {
  const SimpleTextStat({
    super.key,
    required this.categories,
    required this.accounts,
    required this.startDate,
  });

  final List<Account> accounts;
  final List<TransactionCategory> categories;
  final DateTime startDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Simple Stats for all Transactions',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        FutureBuilder(
          future: DatabaseHelper.instance.getSpending(
              accounts,
              categories,
              DateTimeRange(
                start: startDate,
                end: DateTime.now(),
              )),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Balance :',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  BalanceText(snapshot.data as double),
                ],
              );
            } else if (snapshot.hasError) {
              throw snapshot.error!;
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        FutureBuilder(
          future: DatabaseHelper.instance.getTransactionCount(
            accounts,
            categories,
            DateTimeRange(
              start: startDate,
              end: DateTime.now(),
            ),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount of Transactions:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              throw snapshot.error!;
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}
