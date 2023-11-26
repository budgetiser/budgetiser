// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/recurring_data.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:budgetiser/shared/tempData/categories.dart' as cats;
import 'package:flutter/material.dart';

List<Color> _availableColors = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.indigo,
  Colors.amber,
  Colors.deepOrange,
  Colors.cyan,
];

/// ************************
///
///     ACCOUNT SECTION
///
/// ************************

class Accs {
  final int _idx;
  const Accs._(this._idx);
  int toInt() {
    return _idx;
  }

  static const Accs wallet = Accs._(0);
  static const Accs creditCard = Accs._(1);
  static const Accs savings = Accs._(2);
  static const Accs investments = Accs._(3);
  static const Accs payPal = Accs._(4);
  static const Accs studentsID = Accs._(5);
}

List<Account> getExampleAccounts() {
  List<Account> accounts = [];
  List<IconData> icons = [
    Icons.wallet,
    Icons.credit_card,
    Icons.account_balance,
    Icons.show_chart,
    Icons.paypal,
    Icons.perm_identity
  ];
  List<String> names = [
    'Wallet',
    'Credit Card',
    'Savings',
    'Investment',
    'PayPal',
    'Students ID'
  ];

  for (int i = 0; i < icons.length; i++) {
    accounts.add(
      Account(
        id: i + 1,
        name: names[i],
        icon: icons[i],
        color: _availableColors[Random().nextInt(_availableColors.length)],
        balance: 0.0,
        description: '',
      ),
    );
  }

  return accounts;
}

List<Account> TMP_DATA_accountList = getExampleAccounts();

/// ************************
///
///     CATEGORY SECTION
///
/// ************************

List<TransactionCategory> getCategoryList() {
  List<TransactionCategory> list = [];
  int id = 1;
  void addCategory(String name, IconData icon) {
    list.add(
      TransactionCategory(
        id: id,
        name: name,
        icon: icon,
        color: _availableColors[Random().nextInt(_availableColors.length)],
        description: '',
        archived: false,
      ),
    );
    id++;
  }

  // 0-6
  addCategory('Salary', Icons.attach_money);
  addCategory('Business Income', Icons.business);
  addCategory('Commissions', Icons.trending_up);
  addCategory('Investments', Icons.trending_up);
  addCategory('Money Gifts', Icons.card_giftcard);
  addCategory('Side Gigs', Icons.work);
  addCategory('Private Sellings', Icons.shopping_bag);
  // 7-11
  addCategory('Gas', Icons.local_gas_station);
  addCategory('Parking', Icons.local_parking);
  addCategory('Car Maintenance', Icons.car_repair);
  addCategory('Public Transports', Icons.directions_bus);
  addCategory('Bike', Icons.directions_bike);
  // 12-16
  addCategory('Workshops', Icons.event);
  addCategory('Conferences', Icons.event);
  addCategory('Courses', Icons.school);
  addCategory('Coaching', Icons.group);
  addCategory('Books', Icons.menu_book);
  // 17-20
  addCategory('Doctor Bills', Icons.local_hospital);
  addCategory('Hospital Bills', Icons.local_hospital);
  addCategory('Dentist', Icons.local_hospital);
  addCategory('Medical Devices', Icons.medical_services);
  // 21-25
  addCategory('Cinema', Icons.local_movies);
  addCategory('Theater', Icons.theaters);
  addCategory('Subscriptions', Icons.subscriptions);
  addCategory('Memberships', Icons.card_membership);
  addCategory('Hobbies', Icons.sports_esports);
  // 26-29
  addCategory('Rent', Icons.home);
  addCategory('Property Taxes', Icons.home);
  addCategory('Home Repairs', Icons.home_repair_service);
  addCategory('Gardening', Icons.spa);
  // 30-32
  addCategory('Groceries', Icons.shopping_cart);
  addCategory('Take Aways', Icons.food_bank);
  addCategory('Snacks', Icons.fastfood);
  // 33-34
  addCategory('Daycare', Icons.child_care);
  addCategory('Extracurricular Activities', Icons.sports_soccer);
  // 35-38
  addCategory('Life Insurances', Icons.local_hospital);
  addCategory('Home Insurances', Icons.home);
  addCategory('Car Insurances', Icons.directions_car);
  addCategory('Business Insurances', Icons.business);
  // 39-41
  addCategory('Birthday Gifts', Icons.card_giftcard);
  addCategory('Holiday Gifts', Icons.card_giftcard);
  addCategory('Donations', Icons.favorite);
  // 42-46
  addCategory('Electricity Bill', Icons.flash_on);
  addCategory('Water Bill', Icons.opacity);
  addCategory('Heat Bill', Icons.whatshot);
  addCategory('Internet Bill', Icons.wifi);
  addCategory('Phone Billings', Icons.phone);
  // 47-51
  addCategory('Beauty', Icons.spa);
  addCategory('Hygiene', Icons.spa);
  addCategory('Grooming', Icons.spa);
  addCategory('SPA', Icons.spa);
  addCategory('Clothing', Icons.shopping_bag);
  // 52-54
  addCategory('Pet Food', Icons.pets);
  addCategory('Veterinary Bills', Icons.local_hospital);
  addCategory('Pet Training', Icons.pets);
  // 55-57
  addCategory('Car Debt', Icons.credit_card);
  addCategory('Personal Loans', Icons.credit_card);
  addCategory('House debt', Icons.home);

  return list;
}

List<TransactionCategory> TMP_DATA_categoryList = getCategoryList();

/// ************************
///
///     GROUP SECTION
///
/// ************************

List<Group> getGroupList() {
  List<Group> groups = [];
  List<IconData> icons = [
    Icons.add,
    Icons.train,
    Icons.book,
    Icons.medical_services_outlined,
    Icons.movie_creation_outlined,
    Icons.house,
    Icons.no_food,
    Icons.child_care,
    Icons.library_books,
    Icons.card_giftcard,
    Icons.electric_bolt,
    Icons.person,
    Icons.pets,
    Icons.keyboard_double_arrow_down_sharp
  ];
  List<String> names = [
    'Income',
    'Transportation',
    'Personal Development',
    'Medical and Healthcare',
    'Entertainment',
    'Housing',
    'Food',
    'Children',
    'Insurances',
    'Gifts',
    'Essential Bills',
    'Personal Care',
    'Pets',
    'Debt'
  ];
  List<List<TransactionCategory>> categories = [
    TMP_DATA_categoryList.sublist(0, 6 + 1),
    TMP_DATA_categoryList.sublist(7, 11 + 1),
    TMP_DATA_categoryList.sublist(12, 16 + 1),
    TMP_DATA_categoryList.sublist(17, 20 + 1),
    TMP_DATA_categoryList.sublist(21, 25 + 1),
    TMP_DATA_categoryList.sublist(26, 29 + 1),
    TMP_DATA_categoryList.sublist(30, 32 + 1),
    TMP_DATA_categoryList.sublist(33, 34 + 1),
    TMP_DATA_categoryList.sublist(35, 38 + 1),
    TMP_DATA_categoryList.sublist(39, 41 + 1),
    TMP_DATA_categoryList.sublist(42, 46 + 1),
    TMP_DATA_categoryList.sublist(47, 51 + 1),
    TMP_DATA_categoryList.sublist(52, 54 + 1),
    TMP_DATA_categoryList.sublist(55, 57 + 1),
  ];

  for (int i = 0; i < icons.length; i++) {
    groups.add(
      Group(
        id: 1,
        name: names[i],
        icon: icons[i],
        color: _availableColors[Random().nextInt(_availableColors.length)],
        description: '',
        transactionCategories: categories[i],
      ),
    );
  }
  return groups;
}

List<Group> TMP_DATA_groupList = getGroupList();

/// ************************
///
///     TRANSACTION SECTION
///
/// ************************

List<SingleTransaction> getTransactionList() {
  List<SingleTransaction> list = [];

  void addTransaction({
    required String title,
    required String description,
    required List<Accs> accounts,
    required List<cats.Group> categories,
    required List<double> values,
    required List<int> daysInBetween,
    required int amount,
    List<Accs>? toAccounts,
  }) {
    DateTime nextOccurrence = DateTime.now().subtract(
      Duration(days: daysInBetween[0]),
    );
    for (var i = 0; i < amount; i++) {
      list.add(
        SingleTransaction(
          id: i + 1,
          title: title,
          value: values.elementAt(i % values.length),
          category: TMP_DATA_categoryList[
              categories.elementAt(i % categories.length).toInt()],
          account: TMP_DATA_accountList[
              accounts.elementAt(i % accounts.length).toInt()],
          account2: toAccounts == null
              ? null
              : TMP_DATA_accountList[
                  toAccounts.elementAt(i % toAccounts.length).toInt()],
          description: description,
          date: nextOccurrence,
        ),
      );
      nextOccurrence = nextOccurrence.subtract(
        Duration(days: daysInBetween.elementAt((i + 1) % daysInBetween.length)),
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
    accounts: [Accs.creditCard],
    categories: [cats.Income.salary],
    values: [2500],
    daysInBetween: [30],
    amount: 12,
  );
  addTransaction(
    title: 'Overtime Hours',
    description: '',
    accounts: [Accs.savings],
    categories: [cats.Income.salary],
    values: [350, 500],
    daysInBetween: [60, 60, 30, 90],
    amount: 4,
  );
  addTransaction(
    title: 'Birthday Card Gift',
    description: '',
    accounts: [Accs.wallet],
    categories: [cats.Income.moneyGifts],
    values: [15, 20, 15],
    daysInBetween: [10, 20, 3],
    amount: 6,
  );
  addTransaction(
    title: 'Old TV',
    description: 'Sold on Ebay',
    accounts: [Accs.wallet],
    categories: [cats.Income.privateSellings],
    values: [125],
    daysInBetween: [61],
    amount: 1,
  );
  addTransaction(
    title: 'Vintage Selling',
    description: '',
    accounts: [Accs.creditCard],
    categories: [cats.Income.privateSellings],
    values: [17.50, 23.00, 5],
    daysInBetween: [17, 32],
    amount: 3,
  );
  addTransaction(
    title: 'Singing at Ralphs Wedding',
    description: '',
    accounts: [Accs.wallet],
    categories: [cats.Income.sideGigs],
    values: [50],
    daysInBetween: [74],
    amount: 1,
  );
  addTransaction(
    title: 'Savings',
    description: '',
    accounts: [Accs.creditCard],
    toAccounts: [Accs.savings],
    categories: [cats.Income.investments],
    values: [1000],
    daysInBetween: [30],
    amount: 12,
  );

  /// Cats.Transportation
  addTransaction(
    title: 'Gas refill',
    description: '',
    accounts: [Accs.creditCard],
    categories: [cats.Transportation.gas],
    values: [-28.75, -92.88, -47.26, -67.48, -82.46, -86.47, -59.31],
    daysInBetween: [12, 14, 16, 13, 15, 19, 11],
    amount: 7,
  );
  addTransaction(
    title: 'Parking ticket',
    description: '',
    accounts: [
      Accs.creditCard,
      Accs.wallet,
      Accs.wallet,
      Accs.creditCard,
      Accs.wallet
    ],
    categories: [cats.Transportation.parking],
    values: [-4.75, -3.5, -1.5],
    daysInBetween: [5, 10, 6, 9, 14, 15, 13, 11, 8, 7, 3, 4],
    amount: 42,
  );
  addTransaction(
    title: 'New brakes',
    description: '',
    accounts: [Accs.creditCard],
    categories: [cats.Transportation.bike],
    values: [-123.99],
    daysInBetween: [122],
    amount: 1,
  );

  /// Cats.Food
  addTransaction(
    title: 'Groceries',
    description: '',
    accounts: [Accs.creditCard, Accs.creditCard, Accs.wallet],
    categories: [cats.Food.groceries],
    values: [-28.75, -12.88, -37.26, -47.48, -32.46, -26.47, -59.31],
    daysInBetween: [4, 5, 6, 5, 7, 4, 6, 3, 2, 5, 3],
    amount: 40,
  );

  /// Cats.Food
  addTransaction(
    title: 'snacks',
    description: '',
    accounts: [Accs.creditCard],
    categories: [cats.Food.groceries],
    values: [-2],
    daysInBetween: [1],
    amount: 4000,
  );

  /// Cats.Food
  addTransaction(
    title: 'gambling',
    description: '',
    accounts: [Accs.creditCard],
    categories: [cats.Food.groceries],
    values: [-2],
    daysInBetween: [1, 0, 0, 0, 0, 0, 0],
    amount: 4000,
  );

  /// Cats.Entertainment
  addTransaction(
    title: 'Music streaming service',
    description: 'Student subscription',
    accounts: [Accs.creditCard],
    categories: [cats.Entertainment.subscriptions],
    values: [-4.99],
    daysInBetween: [30],
    amount: 7,
  );
  addTransaction(
    title: 'Pc components',
    description: '',
    accounts: [Accs.payPal],
    categories: [cats.Entertainment.hobbies],
    values: [-199.99, -589.45, -35.99, -875, 15],
    daysInBetween: [50, 4, 3, 7, 2, 1],
    amount: 6,
  );

  return list;
}

List<SingleTransaction> TMP_DATA_transactionList = getTransactionList();

/// ************************
///
///     BUDGET SECTION
///
/// ************************

List<Budget> TMP_DATA_budgetList = [
  Budget(
    id: 1,
    name: 'shopping',
    icon: Icons.shopping_bag_outlined,
    color: Colors.red,
    description: '',
    balance: 0.0,
    intervalRepetitions: 30,
    endDate: DateTime.now().add(
      const Duration(days: 30 * 12),
    ),
    startDate: DateTime.now().subtract(
      const Duration(days: 70),
    ),
    intervalAmount: 1,
    intervalUnit: IntervalUnit.month,
    intervalType: IntervalType.fixedInterval,
    isRecurring: true,
    limit: 100,
    transactionCategories: [
      TMP_DATA_categoryList[8],
      TMP_DATA_categoryList[14],
      TMP_DATA_categoryList[18],
    ],
  ),
  Budget(
    id: 2,
    name: 'Transportation',
    icon: Icons.emoji_transportation,
    color: Colors.blue,
    description: '',
    balance: 0.0,
    intervalRepetitions: 3,
    endDate: DateTime.now().add(
      const Duration(days: 70),
    ),
    startDate: DateTime.now().add(
      const Duration(days: 8),
    ),
    intervalAmount: 1,
    intervalUnit: IntervalUnit.month,
    intervalType: IntervalType.fixedInterval,
    isRecurring: true,
    limit: 250,
    transactionCategories: [
      TMP_DATA_categoryList[17],
      TMP_DATA_categoryList[7],
      TMP_DATA_categoryList[0],
    ],
  ),
  Budget(
    id: 3,
    name: 'house',
    icon: Icons.home,
    color: Colors.green,
    description: '',
    balance: 0.0,
    intervalRepetitions: 5,
    endDate: DateTime.now().add(
      const Duration(days: 70),
    ),
    startDate: DateTime.now().subtract(
      const Duration(days: 5),
    ),
    intervalAmount: 3,
    intervalUnit: IntervalUnit.day,
    intervalType: IntervalType.fixedInterval,
    isRecurring: true,
    limit: 500,
    transactionCategories: [],
  ),
  Budget(
    id: 4,
    name: 'other',
    icon: Icons.more,
    color: Colors.orange,
    description: '',
    balance: 0,
    startDate: DateTime.now().subtract(
      const Duration(days: 70),
    ),
    isRecurring: false,
    limit: 500,
    transactionCategories: [
      TMP_DATA_categoryList[3],
      TMP_DATA_categoryList[10],
      TMP_DATA_categoryList[15],
    ],
  ),
  Budget(
    id: 5,
    name: 'sports',
    icon: Icons.more,
    color: Colors.orange,
    description: '',
    balance: 0,
    endDate: DateTime.now().add(
      const Duration(days: 70),
    ),
    startDate: DateTime.now().subtract(
      const Duration(days: 45),
    ),
    intervalRepetitions: 3,
    intervalAmount: 1,
    intervalUnit: IntervalUnit.month,
    intervalType: IntervalType.fixedInterval,
    isRecurring: true,
    limit: 50,
    transactionCategories: [
      TMP_DATA_categoryList[0],
      TMP_DATA_categoryList[2],
      TMP_DATA_categoryList[5],
      TMP_DATA_categoryList[6],
      TMP_DATA_categoryList[7],
      TMP_DATA_categoryList[9],
      TMP_DATA_categoryList[12],
    ],
  ),
];
