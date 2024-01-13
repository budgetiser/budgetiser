import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/transactions/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionExpansionTile extends StatefulWidget {
  const TransactionExpansionTile({
    super.key,
    required this.date,
    required this.count,
    required this.allAccounts,
    required this.accountsFilter,
    required this.categoriesFilter,
    this.initiallyExpanded = false,
  });

  final String date;
  final int count;
  final List<Account> allAccounts;
  final bool initiallyExpanded;
  final List<Account>? accountsFilter;
  final List<TransactionCategory>? categoriesFilter;

  @override
  State<TransactionExpansionTile> createState() =>
      _TransactionExpansionTileState();
}

class _TransactionExpansionTileState extends State<TransactionExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.date),
          Text(widget.count.toString()),
        ],
      ),
      onExpansionChanged: (value) async {
        setState(() {});
      },
      initiallyExpanded: widget.initiallyExpanded,
      controller: ExpansionTileController(),
      children: [
        Consumer<TransactionModel>(builder: (context, value, child) {
          return FutureBuilder<List<SingleTransaction>>(
            future: _future(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.isEmpty) {
                return Container();
              }
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return TransactionItem(
                      // TODO: Bug: no splash effect. probably because of colored container #229
                      transactionData: snapshot.data![index],
                    );
                  },
                ),
              );
            },
          );
        })
      ],
    );
  }

  Future<List<SingleTransaction>> _future() async {
    List<String> yearMonth = widget.date.split('-');

    return TransactionModel().getFilteredTransactionsByMonth(
      inMonth: DateTime(int.parse(yearMonth[0]), int.parse(yearMonth[1])),
      fullAccountList: widget.allAccounts,
      accounts: widget.accountsFilter,
      categories: widget.categoriesFilter,
    );
  }
}
