import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:budgetiser/shared/widgets/balance_text.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon_with_text.dart';
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
    return FutureBuilder(
      future: TransactionModel().getFilteredTransactions(
        accounts,
        categories,
        DateTimeRange(
          start: startDate,
          end: DateTime.now(),
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Expanded(
            child: resultTable(snapshot.data!),
          );
        } else if (snapshot.hasError) {
          throw snapshot.error!;
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget resultTable(List<SingleTransaction> data) {
    double total = roundDouble(
      data.fold(
        0.0,
        (previousValue, element) => previousValue + element.value,
      ),
    );
    int count = data.length;
    return ListView(
      children: [
        FittedBox(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Stat')),
              DataColumn(label: Text('Value')),
            ],
            rows: [
              DataRow(
                cells: [
                  const DataCell(Text('Amount of Transactions')),
                  DataCell(Text(count.toString())),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Text('Total Value')),
                  DataCell(BalanceText(total)),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Text('Mean of Transaction Value')),
                  DataCell(BalanceText(total / count)),
                ],
              ),
            ],
          ),
        ),
        FittedBox(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Value')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Mean')),
            ],
            rows: dataRowsByCategory(data),
          ),
        ),
        FittedBox(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Account 1')),
              DataColumn(label: Text('Value')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Mean')),
            ],
            rows: dataRowsByAccount1(data),
          ),
        ),
      ],
    );
  }

  List<DataRow> dataRowsByCategory(List<SingleTransaction> data) {
    Map<Selectable, (double, int)> groupedItems = data.fold({}, (
      Map<Selectable, (double, int)> map,
      item,
    ) {
      map.putIfAbsent(item.category, () => (0.0, 0));
      map[item.category] =
          (map[item.category]!.$1 + (item.value), map[item.category]!.$2 + 1);

      return map;
    });
    List<DataRow> dataRows = [];
    groupedItems.forEach((key, value) {
      dataRows.add(
        DataRow(
          cells: [
            DataCell(
              SelectableIconWithText(key),
            ),
            DataCell(
              BalanceText(value.$1),
            ),
            DataCell(
              Text(value.$2.toString()),
            ),
            DataCell(
              BalanceText(value.$1 / value.$2),
            ),
          ],
        ),
      );
    });
    return dataRows;
  }

  List<DataRow> dataRowsByAccount1(List<SingleTransaction> data) {
    Map<Selectable, (double, int)> groupedItems = data.fold({}, (
      Map<Selectable, (double, int)> map,
      item,
    ) {
      map.putIfAbsent(item.account, () => (0.0, 0));
      map[item.account] =
          (map[item.account]!.$1 + (item.value), map[item.account]!.$2 + 1);

      return map;
    });
    List<DataRow> dataRows = [];
    groupedItems.forEach((key, value) {
      dataRows.add(
        DataRow(
          cells: [
            DataCell(
              SelectableIconWithText(key),
            ),
            DataCell(
              BalanceText(value.$1),
            ),
            DataCell(
              Text(value.$2.toString()),
            ),
            DataCell(
              BalanceText(value.$1 / value.$2),
            ),
          ],
        ),
      );
    });
    return dataRows;
  }
}
