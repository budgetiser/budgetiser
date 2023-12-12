import 'package:budgetiser/db/single_transaction_provider.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/widgets/items/transaction_item.dart';
import 'package:flutter/material.dart';

class TransactionExpansionTile extends StatefulWidget {
  const TransactionExpansionTile({
    super.key,
    required this.date,
    required this.count,
    required this.allAccounts,
    required this.accountFilter,
    required this.categoryFilter,
    this.initiallyExpanded = false,
  });

  // TODO: Change name
  final String date;
  final int count;
  final List<Account> allAccounts;
  final bool initiallyExpanded;
  final Account? accountFilter;
  final TransactionCategory? categoryFilter;

  @override
  State<TransactionExpansionTile> createState() =>
      _TransactionExpansionTileState();
}

class _TransactionExpansionTileState extends State<TransactionExpansionTile> {
  dynamic _futureFunction;

  @override
  Widget build(BuildContext context) {
    if (widget.initiallyExpanded) {
      _futureFunction = _future();
    }
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.date),
          Text(widget.count.toString()),
        ],
      ),
      onExpansionChanged: (value) async {
        setState(() {
          _futureFunction = value ? _future() : null;
        });
      },
      initiallyExpanded: widget.initiallyExpanded,
      controller: ExpansionTileController(),
      children: [
        FutureBuilder<List<SingleTransaction>>(
          future: _futureFunction,
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
                    // TODO: Bug: no splash effect. probably because of colored container
                    transactionData: snapshot.data![index],
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }

  Future<List<SingleTransaction>> _future() async {
    List<String> yearMonth = widget.date.split('-');

    return TransactionModel().getFilteredTransactionsByMonth(
      inMonth: DateTime(int.parse(yearMonth[0]), int.parse(yearMonth[1])),
      fullAccountList: widget.allAccounts,
      account: widget.accountFilter,
      category: widget.categoryFilter,
    );
  }
}
