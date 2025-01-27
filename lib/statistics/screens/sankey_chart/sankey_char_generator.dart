import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// Sankey Chart Generator
String generateSankeyChart(
  BuildContext context,
  List<Account> accounts,
  List<TransactionCategory> categories,
) {
  String returnString = '// Account colors:\n';
  returnString += generateAccountList(accounts);
  returnString += '\n// Category colors:\n';
  returnString += generateCategoryList(categories);
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
