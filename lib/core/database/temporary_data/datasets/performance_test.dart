import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/temporary_data/dataset.dart';
import 'package:flutter/material.dart';

class PerformanceTestDataset extends DemoDataset {
  static final PerformanceTestDataset _instance =
      PerformanceTestDataset._internal();

  /// Dataset uses singleton
  factory PerformanceTestDataset() {
    return _instance;
  }
  PerformanceTestDataset._internal() {
    categoryList = generateCategories();
    accountList = generateAccounts();
    transactionList = generateTransactions();
    budgetList = generateBudgets();
  }

  late List<Account> accountList;
  late List<Budget> budgetList;
  late List<TransactionCategory> categoryList;
  late List<SingleTransaction> transactionList;

  List<Account> generateAccounts() {
    return List<Account>.generate(
      1000,
      (int index) {
        index++; // db starts with index 1
        return Account(
          name: 'Account $index',
          icon: Icons.account_balance,
          color: Colors.green,
          id: index,
          balance: (index * 110) % 10000,
        );
      },
    );
  }

  List<Budget> generateBudgets() {
    var units = [
      IntervalUnit.day,
      IntervalUnit.week,
      IntervalUnit.month,
      IntervalUnit.quarter,
      IntervalUnit.year,
      IntervalUnit.endless,
    ];
    return List<Budget>.generate(
      100,
      (int index) {
        index++; // db starts with index 1
        return Budget(
          name: 'Budget $index',
          icon: Icons.monetization_on,
          color: Colors.green,
          id: index,
          description: 'I am a budget',
          intervalUnit: units[index % units.length],
          maxValue: index * 8 % 150,
          transactionCategories: categoryList.sublist(
            0,
            index % categoryList.length,
          ),
        );
      },
    );
  }

  List<TransactionCategory> generateCategories() {
    return List<TransactionCategory>.generate(
      1000,
      (int index) {
        index++; // db starts with index 1
        return TransactionCategory(
          name: 'Category $index',
          icon: Icons.category,
          color: Colors.green,
          id: index,
          archived: index % 16 == 0,
          description: 'I am a category',
        );
      },
    );
  }

  List<SingleTransaction> generateTransactions() {
    int everyXisPositive = 6;
    int everyXhas2Accounts = 20;
    return List<SingleTransaction>.generate(
      10000,
      (int index) {
        var value = index * 5.1 % 50; // cap to max +- 50
        if ((index % everyXisPositive) != 0 &&
            (index % everyXhas2Accounts) != 0) {
          value *= -1;
        }
        return SingleTransaction(
          account: accountList[(index % 10)],
          categories: categoryList,
          date: DateTime(2020, 1, 1).add(Duration(hours: index)),
          id: index + 1,
          title: 'Transaction ${index + 1}',
          value: value,
          description: 'I am a transaction',
          account2: index % everyXhas2Accounts == 0
              ? accountList.last // account2 cannot collide with account1 list
              : null,
        );
      },
    );
  }

  @override
  List<Account> getAccounts() {
    return accountList;
  }

  @override
  List<Budget> getBudgets() {
    return budgetList;
  }

  @override
  List<TransactionCategory> getCategories() {
    return categoryList;
  }

  @override
  List<SingleTransaction> getTransactions() {
    return transactionList;
  }
}
