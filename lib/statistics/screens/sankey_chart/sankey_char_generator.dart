import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

/// Sankey Chart Generator
///
/// Generates a string that can be used to generate a sankey chart.
Future<String> generateSankeyChart(
  BuildContext context,
  List<Account> accounts,
  List<TransactionCategory> categories,
  DateTimeRange dateRange,
) async {
  String returnString =
      '// Budgetiser export from ${dateAsDDMMYYYY(dateRange.start)} to ${dateAsDDMMYYYY(dateRange.end)}\n';
  returnString += '\n// Account colors:\n';
  returnString += generateAccountList(accounts);
  returnString += '\n// Category colors:\n';
  returnString += generateCategoryList(categories);
  returnString += '\n// Transactions:\n';
  returnString +=
      await generateTransactionList(context, accounts, categories, dateRange);
  return returnString;
}

String generateCategoryList(List<TransactionCategory> categories) {
  String returnString = '';
  for (TransactionCategory category in categories) {
    var color = category.color
        .toHexString(enableAlpha: false)
        .substring(2); // Remove alpha
    returnString += ':${category.name} #$color\n';
  }
  return returnString;
}

String generateAccountList(List<Account> accounts) {
  String returnString = '';
  for (Account account in accounts) {
    var color = account.color
        .toHexString(enableAlpha: false)
        .substring(2); // Remove alpha
    returnString += ':${account.name} #$color\n';
  }
  return returnString;
}

Future<String> generateTransactionList(
  BuildContext context,
  List<Account> accounts,
  List<TransactionCategory> categories,
  DateTimeRange dateRange,
) async {
  List<SingleTransaction> allTransactions =
      await Provider.of<TransactionModel>(context, listen: false)
          .getAllTransactions();

  String returnString = '';
  returnString += '// transactions len: ${allTransactions.length}\n';
  return returnString;
}
