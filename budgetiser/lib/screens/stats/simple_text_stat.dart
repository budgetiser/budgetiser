import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:budgetiser/shared/widgets/smallStuff/balanceText.dart';
import 'package:flutter/material.dart';

class SimpleTextStat extends StatelessWidget {
  const SimpleTextStat({
    Key? key,
    this.category,
    this.account,
  }) : super(key: key);

  final Account? account;
  final TransactionCategory? category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Simple Stats for all Transactions',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          FutureBuilder(
            future: DatabaseHelper.instance.getSpending(account!, category!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Balance :',
                      style: Theme.of(context).textTheme.bodyText1,
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
            future: DatabaseHelper.instance
                .getTransactionCount(account!, category!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount of Transactions:',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      '${snapshot.data}',
                      style: Theme.of(context).textTheme.bodyText1,
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
      ),
    );
  }
}
