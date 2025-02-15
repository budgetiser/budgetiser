import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/temporary_data/dataset.dart';
import 'package:flutter/material.dart';

class BeautifulDataset extends DemoDataset {
  static final BeautifulDataset _instance = BeautifulDataset._internal();

  /// Dataset uses singleton
  factory BeautifulDataset() {
    return _instance;
  }
  BeautifulDataset._internal() {
    categoryList = generateCategories();
    // accountList = generateAccounts();
    // budgetList = generateBudgets();
    transactionList = generateTransactions();
  }

  // late List<Account> accountList;
  // late List<Budget> budgetList;
  late List<TransactionCategory> categoryList;
  late List<SingleTransaction> transactionList;

  @override
  List<Account> getAccounts() {
    return [
      Account(
        name: 'Credit Card',
        icon: Icons.credit_card_rounded,
        color: Colors.black,
        id: 1,
        balance: -500,
      ),
    ];
  }

  @override
  List<Budget> getBudgets() {
    return [
      Budget(
        id: 1,
        name: 'shopping',
        icon: Icons.shopping_bag_outlined,
        color: Colors.red,
        description: '',
        intervalUnit: IntervalUnit.month,
        maxValue: 100,
        transactionCategories: [],
      ),
    ];
  }

  @override
  List<TransactionCategory> getCategories() {
    return categoryList;
  }

  @override
  List<SingleTransaction> getTransactions() {
    return transactionList;
  }

  List<TransactionCategory> generateCategories() {
    List<TransactionCategory> list = [];
    int id = 1;
    void addCategory(String name, IconData icon, Color color) {
      list.add(
        TransactionCategory(
          id: id,
          name: name,
          icon: icon,
          color: color,
          description: '',
          archived: false,
        ),
      );
      id++;
    }

    // 0-6
    addCategory('Salary', Icons.attach_money, Colors.black);
    addCategory('Business Income', Icons.business, Colors.green);
    addCategory('Commissions', Icons.trending_up, Colors.orange);
    addCategory('Investments', Icons.trending_up, Colors.green);

    return list;
  }

  List<SingleTransaction> generateTransactions() {
    List<SingleTransaction> list = [];
    int currentId = 1;

    void addTransaction({
      required String title,
      required String description,
      required List<Account> accounts1,
      required List<TransactionCategory> categories,
      required List<double> values,
      required List<int> daysInBetween,
      required int amount,
      Duration? initialOffset,
      List<Account>? accounts2,
    }) {
      late DateTime nextOccurrence;
      if (initialOffset == null) {
        nextOccurrence = DateTime.now().subtract(
          Duration(days: daysInBetween[0]),
        );
      } else {
        nextOccurrence = DateTime.now().subtract(
          initialOffset,
        );
      }

      for (var i = 0; i < amount; i++) {
        list.add(
          SingleTransaction(
            id: currentId++,
            title: title,
            value: values.elementAt(i % values.length),
            category: categories.elementAt(i % categories.length),
            account: accounts1.elementAt(i % accounts1.length),
            account2: accounts2?.elementAt(i % accounts2.length),
            description: description,
            date: nextOccurrence,
          ),
        );
        nextOccurrence = nextOccurrence.subtract(
          Duration(
              days: daysInBetween.elementAt((i + 1) % daysInBetween.length)),
        );
      }
    }

    /// PLEASE NOTICE!
    /// This section is for adding all transactions to the temporary data list.
    /// Please sort new transactions according to their respective group.

    ///Cats.Income
    addTransaction(
      title: 'Monthly Salary',
      description: '',
      accounts1: [getAccounts()[0]],
      categories: [categoryList[0]],
      values: [2500],
      daysInBetween: [30],
      amount: 12,
    );
    addTransaction(
      title: 'Overtime Hours',
      description: '',
      accounts1: [getAccounts()[0]],
      categories: [categoryList[0]],
      values: [350, 500],
      daysInBetween: [60, 60, 30, 90],
      amount: 4,
    );
    addTransaction(
      title: 'Hobby Shop',
      description: '',
      accounts1: [getAccounts()[0]],
      categories: [categoryList[1]],
      values: [15, 20, 15],
      daysInBetween: [10, 20, 3],
      amount: 6,
    );
    addTransaction(
      title: 'Old TV',
      description: 'Sold on Ebay',
      accounts1: [getAccounts()[0]],
      categories: [categoryList[0]],
      values: [125],
      daysInBetween: [61],
      amount: 1,
    );

    return list;
  }
}
