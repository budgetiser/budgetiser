import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/selectable.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/shared/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class Flow {
  Selectable source;
  Selectable target;
  double value;
  Color color;

  Flow({
    required this.source,
    required this.target,
    required this.value,
    required this.color,
  }) : assert(value >= 0);

  Flow copyWith({required Selectable source}) {
    return Flow(
      source: source,
      target: target,
      value: value,
      color: color,
    );
  }
}

class SankeyChart {
  bool combineTransactions;
  bool applyCategoryHierarchy;
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
    this.applyCategoryHierarchy = true,
    this.includeTypeAnnotations = true,
    this.includeNodeColor = true,
    this.includeFlowColor = true,
    this.useBracesForFlowColor = false,
  }) : assert(
          (combineTransactions && applyCategoryHierarchy) ||
              (!combineTransactions && !applyCategoryHierarchy),
          'combineTransactions and applyCategoryHierarchy must both be true or both be false',
        );

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

    List<SingleTransaction> mergedTransactions;
    if (combineTransactions) {
      mergedTransactions = _mergeTransactions(allTransactions);
    } else {
      mergedTransactions = allTransactions;
    }

    List<Flow> finalTransactions;
    if (applyCategoryHierarchy) {
      finalTransactions =
          await _applyCategoryHierarchy(context, mergedTransactions);
    } else {
      finalTransactions = _toFlows(mergedTransactions);
    }

    returnString +=
        '// merged transactions len: ${finalTransactions.length}\n'; // Debug

    // build the string
    for (Flow transaction in finalTransactions) {
      returnString += _generateTransactionString(
        transaction,
      );
    }
    return returnString;
  }

  String _generateTransactionString(
    Flow flow,
  ) {
    var returnString =
        '${nodeName(flow.source)} [${flow.value.toStringAsFixed(2)}] ${nodeName(flow.target)}';
    if (includeFlowColor) {
      if (useBracesForFlowColor) {
        returnString += ' [${_hexString(flow.color)}]';
      } else {
        returnString += ' ${_hexString(flow.color)}';
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
      // Generate a key based on source and target to identify unique paths
      // also this way negative and positive transactions are kept separate
      String key = transaction.value <= 0
          ? '${transaction.account.name}=${transaction.category.name}'
          : '${transaction.category.name}=${transaction.account.name}';
      if (transaction.account2 != null) {
        key += '=${transaction.account2!.name}';
      }

      if (mergedTransactions.containsKey(key)) {
        mergedTransactions[key]!.value += transaction.value;
      } else {
        mergedTransactions[key] = transaction;
      }
    }

    return mergedTransactions.values.toList();
  }

  Future<List<Flow>> _applyCategoryHierarchy(
    BuildContext context,
    List<SingleTransaction> mergedTransactions,
  ) async {
    List<Flow> finalTransactions = [];
    var parentList = await Provider.of<CategoryModel>(context, listen: false)
        .getParentsList();
    for (SingleTransaction transaction in mergedTransactions) {
      if (transaction.account2 != null) {
        finalTransactions.add(
          Flow(
            source: transaction.account,
            target: transaction.account2!,
            value: transaction.value,
            color: transaction.category.color,
          ),
        );
        continue;
      }
      if (!parentList.containsKey(transaction.category.id)) {
        finalTransactions.add(
          Flow(
            source: transaction.account,
            target: transaction.category,
            value: transaction.value.abs(),
            color: transaction.account.color,
          ),
        );
      } else {
        List<int> parents = parentList[transaction.category.id]!;
        Selectable lastSource = transaction.account;
        for (int parent in parents) {
          TransactionCategory parentCategory =
              await Provider.of<CategoryModel>(context, listen: false)
                  .getCategory(parent);
          finalTransactions.add(
            Flow(
              source: lastSource,
              target: parentCategory,
              value: transaction.value.abs(),
              color: transaction.category.color,
            ),
          );
          lastSource = parentCategory;
        }
        finalTransactions.add(
          Flow(
            source: lastSource,
            target: transaction.category,
            value: transaction.value.abs(),
            color: transaction.category.color,
          ),
        );
      }
    }
    return finalTransactions;
  }

  List<Flow> _toFlows(List<SingleTransaction> transactions) {
    List<Flow> flows = [];
    for (SingleTransaction transaction in transactions) {
      if (transaction.account2 != null) {
        flows.add(
          Flow(
            source: transaction.account,
            target: transaction.account2!,
            value: transaction.value.abs(),
            color: transaction.category.color,
          ),
        );
        continue;
      }
      if (transaction.value < 0) {
        flows.add(
          Flow(
            source: transaction.account,
            target: transaction.category,
            value: transaction.value.abs(),
            color: transaction.category.color,
          ),
        );
      } else {
        flows.add(
          Flow(
            source: transaction.category,
            target: transaction.account,
            value: transaction.value,
            color: transaction.category.color,
          ),
        );
      }
    }
    return flows;
  }
}
