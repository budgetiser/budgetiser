import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
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

/// Generates a list of transactions in the format:
///
/// 'SourceNodeName [Amount] TargetNodeName'
///
/// If [combineTransactions] is true, transactions with the same source and target will be combined.
Future<String> generateTransactionList(
  BuildContext context,
  List<Account> accounts,
  List<TransactionCategory> categories,
  DateTimeRange dateRange, {
  bool combineTransactions = true,
}) async {
  List<Account> allAccounts =
      await Provider.of<AccountModel>(context, listen: false).getAllAccounts();
  List<SingleTransaction> allTransactions =
      await Provider.of<TransactionModel>(context, listen: false)
          .getFilteredTransactions(
    dateTimeRange: dateRange,
    accounts: accounts,
    categories: categories,
    fullAccountList: allAccounts,
  );

  String returnString = '';
  returnString += '// transactions len: ${allTransactions.length}\n'; // Debug

  List<SingleTransaction> finalTransactions;
  if (combineTransactions) {
    finalTransactions = mergeTransactions(allTransactions);
  } else {
    finalTransactions = allTransactions;
  }

  returnString +=
      '// merged transactions len: ${finalTransactions.length}\n'; // Debug

  for (SingleTransaction transaction in finalTransactions) {
    if (transaction.account2 != null) {
      print('skipping transaction with account2');
      continue;
    }
    if (transaction.value < 0) {
      returnString +=
          '${transaction.account.name} [${transaction.value.abs()}] ${transaction.category.name}\n';
    } else {
      returnString +=
          '${transaction.category.name} [${transaction.value}] ${transaction.account.name}\n';
    }
  }

  return returnString;
}

/// Merges transactions with the same source and target.
List<SingleTransaction> mergeTransactions(
  List<SingleTransaction> allTransactions,
) {
  Map<String, SingleTransaction> mergedTransactions = {};

  for (SingleTransaction transaction in allTransactions) {
    if (transaction.account2 != null) {
      print('Skipping transaction with account2');
      continue;
    }

    // Generate a key based on source and target to identify unique paths
    // also this way negative and positive transactions are kept separate
    String key = transaction.value <= 0
        ? '${transaction.account.name}=${transaction.category.name}'
        : '${transaction.category.name}=${transaction.account.name}';

    if (mergedTransactions.containsKey(key)) {
      mergedTransactions[key]!.value += transaction.value;
    } else {
      mergedTransactions[key] = transaction;
    }
  }

  return mergedTransactions.values.toList();
}
