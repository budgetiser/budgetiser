import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class SankeyChart {
  bool combineTransactions;
  bool includeTypeAnnotations;
  bool includeNodeColor;
  bool includeFlowColor;
  bool useBracesForFlowColor;

  /// Generates a string that can be used to generate a sankey chart.
  ///
  /// Use the [generateSankeyChart] method to generate a string that can be used to generate a sankey chart.
  ///
  /// * [combineTransactions] - If true, transactions with the same source and target will be combined.
  /// * [includeTypeAnnotations] - If true, the account and category names are appended with their type.
  /// * [includeNodeColor] - If true, the account and category node colors are included in the output.
  /// * [includeFlowColor] - If true, the flow color is included in the output. Color is based on the source node.
  /// * [useBracesForFlowColor] - If true, the flow color is enclosed in braces.
  SankeyChart({
    this.combineTransactions = true,
    this.includeTypeAnnotations = false,
    this.includeNodeColor = true,
    this.includeFlowColor = true,
    this.useBracesForFlowColor = false,
  });

  /// Generates a string that can be used to generate a sankey chart.
  Future<String> generateSankeyChart(
    BuildContext context,
    List<Account> accounts,
    List<TransactionCategory> categories,
    DateTimeRange dateRange,
  ) async {
    String returnString =
        '// Budgetiser export from ${dateAsDDMMYYYY(dateRange.start)} to ${dateAsDDMMYYYY(dateRange.end)}\n';
    if (includeNodeColor) {
      returnString += '\n// Account colors:\n';
      returnString += _generateAccountList(accounts);
      returnString += '\n// Category colors:\n';
      returnString += _generateCategoryList(categories);
    }
    returnString += '\n// Transactions:\n';
    returnString += await _generateTransactionList(
      context,
      accounts,
      categories,
      dateRange,
    );
    return returnString;
  }

  /// List of categories with their colors in the format: ':CategoryName #000000'
  String _generateCategoryList(List<TransactionCategory> categories) {
    String returnString = '';
    for (TransactionCategory category in categories) {
      returnString += ':${nodeName(category)} ${_hexString(category.color)}\n';
    }
    return returnString;
  }

  /// List of accounts with their colors in the format: ':AccountName #000000'
  String _generateAccountList(List<Account> accounts) {
    String returnString = '';
    for (Account account in accounts) {
      returnString += ':${nodeName(account)} ${_hexString(account.color)}\n';
    }
    return returnString;
  }

  /// Converts a [Color] to a hex string (#000000) without the alpha channel.
  String _hexString(Color color) {
    return colorToHex(
      color,
      enableAlpha: false,
      includeHashSign: true,
    );
  }

  /// Generates a list of transactions in the format:
  ///
  /// 'SourceNodeName [Amount] TargetNodeName'
  ///
  /// If [combineTransactions] is true, transactions with the same source and target will be combined.
  /// If [includeTypeAnnotations] is true, the account and category names are appended with their type.
  Future<String> _generateTransactionList(
    BuildContext context,
    List<Account> accounts,
    List<TransactionCategory> categories,
    DateTimeRange dateRange,
  ) async {
    List<Account> allAccounts =
        await Provider.of<AccountModel>(context, listen: false)
            .getAllAccounts();
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
      finalTransactions = _mergeTransactions(allTransactions);
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
        returnString += _generateTransactionString(
          transaction.account,
          transaction.category,
          transaction.value.abs(),
          transaction.account.color,
        );
      } else {
        returnString += _generateTransactionString(
          transaction.category,
          transaction.account,
          transaction.value.abs(),
          transaction.category.color,
        );
      }
    }
    return returnString;
  }

  String _generateTransactionString(
    Selectable source,
    Selectable target,
    double value,
    Color color,
  ) {
    assert(value >= 0);

    var returnString =
        '${nodeName(source)} [${value.toStringAsFixed(2)}] ${nodeName(target)}';
    if (includeFlowColor) {
      if (useBracesForFlowColor) {
        returnString += ' [${_hexString(color)}]';
      } else {
        returnString += ' ${_hexString(color)}';
      }
    }
    returnString += '\n';
    return returnString;
  }

  /// Gets the name of a node with type annotations if [includeTypeAnnotations] is true.
  String nodeName(Selectable node) {
    return (includeTypeAnnotations
            ? (node.runtimeType == TransactionCategory ? '[C]' : '[A]')
            : '') +
        node.name;
  }

  /// Merges transactions with the same source and target.
  List<SingleTransaction> _mergeTransactions(
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
}
