import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/temporary_data/dataset.dart';
import 'package:flutter/material.dart';

class BeautifulDataset extends DemoDataset {
  static final BeautifulDataset _instance = BeautifulDataset._internal();

  late List<Account> accountList;
  late List<TransactionCategory> categoryList;
  late List<Budget> budgetList;
  late List<SingleTransaction> transactionList;

  /// Dataset uses singleton
  factory BeautifulDataset() {
    return _instance;
  }

  BeautifulDataset._internal() {
    accountList = generateAccounts();
    categoryList = generateCategories();
    budgetList = generateBudgets();
    transactionList = generateTransactions();
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

  List<Account> generateAccounts() {
    List<Account> list = [];
    int id = 1;
    void addAccount(
      String name,
      IconData icon,
      Color color, {
      bool isArchived = false,
    }) {
      list.add(
        Account(
          id: id,
          name: name,
          icon: icon,
          color: color,
          balance: 0,
          archived: isArchived,
        ),
      );
      id++;
    }

    addAccount('Credit Card', Icons.credit_card_rounded, Colors.pinkAccent);
    addAccount('Debit Card', Icons.business_outlined, Colors.red);
    addAccount('Savings', Icons.account_balance, Colors.green);
    addAccount('Cash', Icons.attach_money, Colors.orange);
    addAccount(
      'Old bank account',
      Icons.account_balance_wallet,
      Colors.blue,
      isArchived: true,
    );

    return list;
  }

  List<TransactionCategory> generateCategories() {
    List<TransactionCategory> list = [];
    int id = 1;
    void addCategory(
      String name,
      IconData icon,
      Color color, {
      int? parentId,
    }) {
      list.add(
        TransactionCategory(
          id: id,
          name: name,
          icon: icon,
          color: color,
          description: '',
          archived: false,
          parentID: parentId,
        ),
      );
      id++;
    }

    // top level categories
    addCategory('Income', Icons.attach_money, Colors.green);
    addCategory('Hobby', Icons.star, Colors.blue);
    addCategory('Mobility', Icons.directions_car, Colors.blue);
    addCategory('Housing', Icons.home, Colors.brown);
    addCategory('Food', Icons.fastfood, Colors.orange); // id=5
    addCategory('Entertainment', Icons.movie, Colors.purple);
    addCategory('Transfers', Icons.swap_horiz, Colors.grey);
    addCategory('Other', Icons.category, Colors.grey); // id=8

    // subcategories
    addCategory('Salary', Icons.money, Colors.green, parentId: 1);
    addCategory('Freelance', Icons.work, Colors.green, parentId: 1);

    addCategory('Events', Icons.event, Colors.blue, parentId: 2);
    addCategory('Books', Icons.book, Colors.blue, parentId: 2);
    addCategory('Music', Icons.music_note, Colors.blue, parentId: 2);
    addCategory('Sports', Icons.fitness_center, Colors.blue, parentId: 2);

    addCategory('Car', Icons.directions_car, Colors.blue, parentId: 3);
    addCategory('Public Transport', Icons.train, Colors.blue, parentId: 3);
    addCategory('Bicycle', Icons.pedal_bike, Colors.blue, parentId: 3);

    addCategory('Rent', Icons.home, Colors.brown, parentId: 4); // id=18
    addCategory('Utilities', Icons.lightbulb, Colors.brown, parentId: 4);
    addCategory('Interior', Icons.chair, Colors.brown, parentId: 4);

    addCategory('Groceries', Icons.shopping_cart, Colors.orange, parentId: 5);
    addCategory('Dining Out', Icons.restaurant, Colors.orange, parentId: 5);
    addCategory('Snacks', Icons.fastfood, Colors.orange, parentId: 5);
    addCategory('Drinks', Icons.local_bar, Colors.orange, parentId: 5); // id=24

    addCategory('Movies', Icons.movie, Colors.purple, parentId: 6);
    addCategory('Concerts', Icons.music_note, Colors.purple, parentId: 6);
    addCategory('Games', Icons.videogame_asset, Colors.purple, parentId: 6);

    addCategory('Bank Transfer', Icons.swap_horiz, Colors.grey, parentId: 7);
    addCategory('Cash Transfer', Icons.money, Colors.grey, parentId: 7);

    addCategory('Charity', Icons.favorite, Colors.red, parentId: 8);
    addCategory('Gifts', Icons.card_giftcard, Colors.pink, parentId: 8);

    // sub-subcategories
    addCategory('Car Insurance', Icons.security, Colors.blue, parentId: 15);
    addCategory('Petrol', Icons.local_gas_station, Colors.blue, parentId: 15);
    addCategory('Repair', Icons.build, Colors.red, parentId: 15); // id=34

    return list;
  }

  List<Budget> generateBudgets() {
    List<Budget> list = [];
    int id = 1;
    void addBudget(
      String name,
      IconData icon,
      Color color,
      IntervalUnit intervalUnit,
      double maxValue,
      List<TransactionCategory> categories,
    ) {
      list.add(
        Budget(
          id: id++,
          name: name,
          icon: icon,
          color: color,
          description: '',
          intervalUnit: intervalUnit,
          maxValue: maxValue,
          transactionCategories: categories,
        ),
      );
    }

    addBudget(
      'Shopping',
      Icons.shopping_bag_outlined,
      Colors.red,
      IntervalUnit.month,
      100,
      [categoryList[19], categoryList[20]],
    );
    addBudget(
      'Food',
      Icons.fastfood,
      Colors.orange,
      IntervalUnit.month,
      200,
      [categoryList[20], categoryList[21], categoryList[22], categoryList[23]],
    );
    addBudget(
      'Entertainment',
      Icons.movie,
      Colors.blue,
      IntervalUnit.month,
      150,
      [categoryList[5]],
    );

    return list;
  }

  List<SingleTransaction> generateTransactions() {
    List<SingleTransaction> list = [];
    int currentId = 1;

    /// duration subtracted from now, the transactions will generate to
    Duration generationTime = Duration(days: 365);

    void addTransaction({
      required String title,
      required String description,
      required List<Account> accounts1,
      required List<TransactionCategory> categories,
      required List<double> values,
      required List<int> daysInBetween,

      /// optional if set amount of transactions required, else the amount will be evaluated by 'generationTime'
      int? amount,
      Duration? initialOffset,
      List<Account>? accounts2,
    }) {
      int startingTransactionCount = list.length;
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

      if (amount != null) {
        assert(amount > 0, 'Amount of transactions must be greater than 0');
      }

      int i = 0;
      while (
          amount == null || list.length < startingTransactionCount + amount) {
        if (amount == null &&
            nextOccurrence.isBefore(DateTime.now().subtract(generationTime))) {
          break; // Stop generating if the date is too far in the past
        }
        list.add(
          SingleTransaction(
            id: currentId++,
            title: title,
            value: values.elementAt(i % values.length),
            categories: categories,
            account: accounts1.elementAt(i % accounts1.length),
            account2: accounts2?.elementAt(i % accounts2.length),
            description: description,
            date: nextOccurrence,
          ),
        );
        nextOccurrence = nextOccurrence.subtract(
          Duration(
            days: daysInBetween.elementAt((i + 1) % daysInBetween.length),
          ),
        );
        i++;
      }
    }

    /// PLEASE NOTICE!
    /// This section is for adding all transactions to the temporary data list.
    /// Please sort new transactions according to their respective group.

    // Income
    addTransaction(
      title: 'Monthly Salary',
      description: '',
      accounts1: [accountList[1]],
      categories: [categoryList[8]],
      values: [2000],
      daysInBetween: [30],
      amount: 13,
      initialOffset: Duration(days: 5),
    );
    addTransaction(
      title: 'Overtime Hours',
      description: '',
      accounts1: [accountList[1]],
      categories: [categoryList[8]],
      values: [350, 500],
      daysInBetween: [60, 60, 30, 90],
      amount: 4,
      initialOffset: Duration(days: 5),
    );
    addTransaction(
      title: 'Freelance',
      description: '',
      accounts1: [accountList[1]],
      categories: [categoryList[9]],
      values: [15, 20, 15],
      daysInBetween: [10, 20, 3],
    );

    // Hobby
    addTransaction(
      title: 'Entry Fee',
      description: 'Event with my friends',
      accounts1: [accountList[1]],
      categories: [categoryList[10]],
      values: [-50],
      daysInBetween: [90],
      amount: 3,
    );
    addTransaction(
      title: 'Book Purchase',
      description: 'New book from my favorite author',
      accounts1: [accountList[1]],
      categories: [categoryList[11]],
      values: [-20, -25],
      daysInBetween: [30, 60],
    );
    addTransaction(
      title: 'Music Subscription',
      description: 'Monthly music streaming service',
      accounts1: [accountList[1]],
      categories: [categoryList[12]],
      values: [-10],
      daysInBetween: [30],
      initialOffset: Duration(days: 15),
    );
    addTransaction(
      title: 'Gym Membership',
      description: 'Monthly gym membership fee',
      accounts1: [accountList[1]],
      categories: [categoryList[13]],
      values: [-30],
      daysInBetween: [30],
    );
    addTransaction(
      title: 'Yoga Class',
      description: '',
      accounts1: [accountList[1], accountList[3]],
      categories: [categoryList[13]],
      values: [-15],
      daysInBetween: [7, 14, 21, 14],
      amount: 10,
    );

    // Mobility
    addTransaction(
      title: 'Car Payment',
      description: 'Monthly car loan payment',
      accounts1: [accountList[1]],
      categories: [categoryList[14]],
      values: [-300],
      daysInBetween: [30],
      initialOffset: Duration(days: 9),
    );
    addTransaction(
      title: 'Car Insurance',
      description: 'Monthly car insurance payment',
      accounts1: [accountList[1]],
      categories: [categoryList[31]],
      values: [-100],
      daysInBetween: [30],
      initialOffset: Duration(days: 5),
    );
    addTransaction(
      title: 'Petrol',
      description: 'Fuel for the car',
      accounts1: [accountList[1]],
      categories: [categoryList[32]],
      values: [-50, -60],
      daysInBetween: [14, 20, 17, 30, 10],
    );
    addTransaction(
      title: 'Car Repair',
      description: 'Fixing the car after an accident',
      accounts1: [accountList[2]],
      categories: [categoryList[33]],
      values: [-450],
      daysInBetween: [100],
      amount: 1,
    );
    addTransaction(
      title: 'Public Transport',
      description: 'Monthly public transport pass',
      accounts1: [accountList[1]],
      categories: [categoryList[15]],
      values: [-50],
      daysInBetween: [30],
      initialOffset: Duration(days: 10),
    );
    addTransaction(
      title: 'Bicycle Maintenance',
      description: '',
      accounts1: [accountList[1]],
      categories: [categoryList[16]],
      values: [-30],
      daysInBetween: [50],
      initialOffset: Duration(days: 5),
    );

    // Housing
    addTransaction(
      title: 'Rent Payment',
      description: 'Monthly rent for the apartment',
      accounts1: [accountList[1]],
      categories: [categoryList[17]],
      values: [-700],
      daysInBetween: [30],
      initialOffset: Duration(days: 2),
    );
    addTransaction(
      title: 'Utilities Bill',
      description: 'Monthly utilities bill',
      accounts1: [accountList[1]],
      categories: [categoryList[18]],
      values: [-150],
      daysInBetween: [30],
      initialOffset: Duration(days: 5),
    );
    addTransaction(
      title: 'Furniture',
      description: 'New sofa for the living room',
      accounts1: [accountList[1]],
      categories: [categoryList[19]],
      values: [-500],
      daysInBetween: [200],
      amount: 1,
    );
    addTransaction(
      title: 'Decorations',
      description: 'New paintings for the walls',
      accounts1: [accountList[3]],
      categories: [categoryList[19]],
      values: [-40],
      daysInBetween: [60, 45, 30],
      initialOffset: Duration(days: 10),
    );

    // Food
    addTransaction(
      title: 'Groceries',
      description: 'Weekly grocery shopping',
      accounts1: [accountList[1]],
      categories: [categoryList[20]],
      values: [-50, -60, -55],
      daysInBetween: [7, 14, 21, 30],
    );
    addTransaction(
      title: 'Dining Out',
      description: 'Dinner at a restaurant',
      accounts1: [accountList[1]],
      categories: [categoryList[21]],
      values: [-30, -40, -35],
      daysInBetween: [10, 20, 30, 27, 15],
    );
    addTransaction(
      title: 'Snacks',
      description: 'Buying snacks for the movie night',
      accounts1: [accountList[1]],
      categories: [categoryList[22]],
      values: [-10, -15],
      daysInBetween: [37, 20, 30, 20],
    );
    addTransaction(
      title: 'Drinks',
      description: 'Buying drinks for the party',
      accounts1: [accountList[1]],
      categories: [categoryList[23]],
      values: [-20, -25],
      daysInBetween: [10, 15, 20],
    );

    // Entertainment
    addTransaction(
      title: 'Movie Ticket',
      description: '',
      accounts1: [accountList[1]],
      categories: [categoryList[24]],
      values: [-12, -15],
      daysInBetween: [37, 20, 30, 20],
    );
    addTransaction(
      title: 'Concert Ticket',
      description: '',
      accounts1: [accountList[1]],
      categories: [categoryList[25]],
      values: [-50, -60],
      daysInBetween: [90],
      amount: 3,
    );
    addTransaction(
      title: 'Game Purchase',
      description: 'Buying a new video game',
      accounts1: [accountList[1]],
      categories: [categoryList[26]],
      values: [-40, -50],
      daysInBetween: [24, 50, 30, 20],
    );

    // Transfers
    addTransaction(
      title: 'Savings Deposit',
      description: 'Transfer to savings account',
      accounts1: [accountList[1]],
      accounts2: [accountList[2]],
      categories: [categoryList[27]],
      values: [200],
      daysInBetween: [30],
    );
    addTransaction(
      title: 'Cash Withdrawal',
      description: 'Withdrawing cash from the ATM',
      accounts1: [accountList[1]],
      accounts2: [accountList[3]],
      categories: [categoryList[28]],
      values: [100],
      daysInBetween: [15, 30, 45],
    );

    // Other
    addTransaction(
      title: 'Charity Donation',
      description: 'Monthly donation to a charity',
      accounts1: [accountList[1]],
      categories: [categoryList[29]],
      values: [-20],
      daysInBetween: [30],
      initialOffset: Duration(days: 10),
    );
    addTransaction(
      title: 'Gift for Friend',
      description: 'Birthday gift for a friend',
      accounts1: [accountList[1]],
      categories: [categoryList[30]],
      values: [-50],
      daysInBetween: [90],
      amount: 2,
    );
    addTransaction(
      title: 'Birthday Gift',
      description: '',
      accounts1: [accountList[3]],
      categories: [categoryList[30]],
      values: [100],
      daysInBetween: [120],
      amount: 1,
    );

    return list;
  }
}
