import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/transactions/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionExpansionTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date),
          Text(count.toString()),
        ],
      ),
      initiallyExpanded: initiallyExpanded,
      controller: ExpansibleController(),
      children: [
        Consumer<TransactionModel>(
          builder: (context, model, child) {
            return FutureBuilder<List<SingleTransaction>>(
              future: _future(model),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return Container();
                }
                DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                return GroupedListView<SingleTransaction, String>(
                  shrinkWrap: true,
                  elements: snapshot.data!,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  groupBy: (element) => dateFormat.format(element.date),
                  groupComparator: (value1, value2) => value2.compareTo(value1),
                  itemComparator: (item1, item2) =>
                      item1.date.compareTo(item2.date),
                  groupSeparatorBuilder: (String value) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  itemBuilder: (c, element) {
                    return TransactionItem(
                      transactionData: element,
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<List<SingleTransaction>> _future(TransactionModel model) async {
    List<String> yearMonth = date.split('-');

    return model.getFilteredTransactionsByMonth(
      inMonth: DateTime(int.parse(yearMonth[0]), int.parse(yearMonth[1])),
      fullAccountList: allAccounts,
      accounts: accountsFilter,
      categories: categoriesFilter,
    );
  }
}
