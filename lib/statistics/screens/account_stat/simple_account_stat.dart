import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:flutter/material.dart';

class SimpleAccountStatTables extends StatelessWidget {
  const SimpleAccountStatTables({
    super.key,
    required this.accounts,
    required this.startDate,
  });

  final List<Account> accounts;
  final DateTime startDate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TransactionModel().getAccountStats(
        accounts,
        DateTimeRange(
          start: startDate,
          end: DateTime.now(),
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error!;
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Expanded(
            child: resultTable(snapshot.data!),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget resultTable(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card.outlined(
          color: Theme.of(context).hoverColor,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: [
                      Icon(
                        IconData(data[index]['icon'],
                            fontFamily: 'MaterialIcons'),
                        color: Color(data[index]['color']),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        data[index]['name'],
                        style: TextStyle(color: Color(data[index]['color'])),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        '${data[index]['count']} Transactions / ${data[index]['transfers']} Transfers',
                        style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: 32,
                  dividerThickness: double.minPositive,
                  showCheckboxColumn: false,
                  horizontalMargin: 16.0,
                  dataRowMaxHeight: 40,
                  dataRowMinHeight: 40,
                  headingRowHeight: 20,
                  clipBehavior: Clip.antiAlias,
                  columns: <DataColumn>[
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.start,
                      label: Text(
                        'Sum',
                        style: TextStyle(color: Color(data[index]['color'])),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      headingRowAlignment: MainAxisAlignment.start,
                      label: Text(
                        'Mean',
                        style: TextStyle(color: Color(data[index]['color'])),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        '+ Sum',
                        style: TextStyle(color: Color(data[index]['color'])),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        '- Sum',
                        style: TextStyle(color: Color(data[index]['color'])),
                      ),
                      numeric: true,
                    ),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            data[index]['sum'].toStringAsFixed(2),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            data[index]['mean'].toStringAsFixed(2),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            data[index]['psum'].toStringAsFixed(2),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            data[index]['nsum'].toStringAsFixed(2),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: data.length,
    );
  }
}
