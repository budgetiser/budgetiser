// ignore_for_file: non_constant_identifier_names

import 'dart:math';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/temporary_data/categories.dart'
    as cats;
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
    Icons.perm_identity,
    Icons.align_horizontal_left_outlined
  ];
  List<String> names = [
    'Wallet',
    'Credit Card',
    'Savings',
    'Investment',
    'PayPal',
    'Students ID',
    'The Incredibly Elongated and Remarkably Extended Account Name of Unparalleled Length and Magnitude'
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
  addCategory(
      'Really long Extracurricular Activities That Enrich and Shape Personal Growth',
      Icons.sports_soccer);
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
///     TRANSACTION SECTION
///
/// ************************

List<SingleTransaction> getTransactionList() {
  List<SingleTransaction> list = [];

  void addTransaction({
    required String title,
    required String description,
    required List<Accs> accounts1,
    required List<cats.Group> categories,
    required List<double> values,
    required List<int> daysInBetween,
    required int amount,
    List<Accs>? accounts2,
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
              accounts1.elementAt(i % accounts1.length).toInt()],
          account2: accounts2 == null
              ? null
              : TMP_DATA_accountList[
                  accounts2.elementAt(i % accounts2.length).toInt()],
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
    accounts1: [Accs.creditCard],
    categories: [cats.Income.salary],
    values: [2500],
    daysInBetween: [30],
    amount: 12,
  );
  addTransaction(
    title: 'Overtime Hours',
    description: '',
    accounts1: [Accs.savings],
    categories: [cats.Income.salary],
    values: [350, 500],
    daysInBetween: [60, 60, 30, 90],
    amount: 4,
  );
  addTransaction(
    title: 'Birthday Card Gift',
    description: '',
    accounts1: [Accs.wallet],
    categories: [cats.Income.moneyGifts],
    values: [15, 20, 15],
    daysInBetween: [10, 20, 3],
    amount: 6,
  );
  addTransaction(
    title: 'Old TV',
    description: 'Sold on Ebay',
    accounts1: [Accs.wallet],
    categories: [cats.Income.privateSellings],
    values: [125],
    daysInBetween: [61],
    amount: 1,
  );
  addTransaction(
    title: 'Vintage Selling',
    description: '',
    accounts1: [Accs.creditCard],
    categories: [cats.Income.privateSellings],
    values: [17.50, 23.00, 5],
    daysInBetween: [17, 32],
    amount: 3,
  );
  addTransaction(
    title:
        'Singing at Ralphs Wedding - A Melodic Celebration of Union, Joy, and Everlasting Commitment',
    description:
        'Embark on a soulful musical journey as we bring to life the enchanting melodies at Ralphs Wedding. Join us in a harmonious celebration of love, unity, and everlasting commitment. rom heartfelt ballads to joyous tunes, our carefully curated musical repertoire promises to serenade the couple and guests alike, creating unforgettable moments filled with emotion and melody. Allow the power of song to amplify the beauty of this special day, weaving a symphony of love that resonates throughout Ralphs Wedding celebration',
    accounts1: [Accs.wallet],
    categories: [cats.Income.sideGigs],
    values: [50],
    daysInBetween: [10],
    amount: 1,
  );
  addTransaction(
    title: 'Savings',
    description: '',
    accounts1: [Accs.creditCard],
    accounts2: [Accs.savings],
    categories: [cats.Income.investments],
    values: [1000],
    daysInBetween: [30],
    amount: 12,
  );

  /// Cats.Transportation
  addTransaction(
    title: 'Gas refill',
    description: '',
    accounts1: [Accs.creditCard],
    categories: [cats.Transportation.gas],
    values: [-28.75, -92.88, -47.26, -67.48, -82.46, -86.47, -59.31],
    daysInBetween: [12, 14, 16, 13, 15, 19, 11],
    amount: 7,
  );
  addTransaction(
    title: 'Parking ticket',
    description: '',
    accounts1: [
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
    accounts1: [Accs.creditCard],
    categories: [cats.Transportation.bike],
    values: [-123.99],
    daysInBetween: [122],
    amount: 1,
  );

  /// Cats.Food
  addTransaction(
    title: 'Groceries',
    description: '',
    accounts1: [Accs.creditCard, Accs.creditCard, Accs.wallet],
    categories: [cats.Food.groceries],
    values: [-28.75, -12.88, -37.26, -47.48, -32.46, -26.47, -59.31],
    daysInBetween: [4, 5, 6, 5, 7, 4, 6, 3, 2, 5, 3],
    amount: 40,
  );

  addTransaction(
    title: 'snacks',
    description: '',
    accounts1: [Accs.creditCard, Accs.wallet],
    categories: [cats.Food.groceries],
    values: [-2],
    daysInBetween: [1, 4, 2],
    amount: 100,
  );

  /// Cats.Entertainment
  addTransaction(
    title: 'Music streaming service',
    description: 'Student subscription',
    accounts1: [Accs.creditCard],
    categories: [cats.Entertainment.subscriptions],
    values: [-4.99],
    daysInBetween: [30],
    amount: 7,
  );

  addTransaction(
    title: 'Pc components',
    description: '',
    accounts1: [Accs.payPal],
    categories: [cats.Entertainment.hobbies],
    values: [-199.99, -589.45, -35.99, -875, 15],
    daysInBetween: [50, 4, 3, 7, 2, 1],
    amount: 6,
  );

  addTransaction(
    title: 'gambling',
    description: '',
    accounts1: [Accs.creditCard, Accs.savings],
    categories: [cats.Food.groceries],
    values: [-200, 150, 69],
    daysInBetween: [1, 5, 8, 4],
    amount: 10,
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
    intervalUnit: IntervalUnit.month,
    maxValue: 100,
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
    intervalUnit: IntervalUnit.month,
    maxValue: 250,
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
    intervalUnit: IntervalUnit.day,
    maxValue: 500,
    transactionCategories: [],
  ),
  Budget(
    id: 4,
    name: 'other',
    icon: Icons.more,
    color: Colors.orange,
    description: '',
    maxValue: 500,
    intervalUnit: IntervalUnit.month,
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
    intervalUnit: IntervalUnit.month,
    maxValue: 50,
    transactionCategories: TMP_DATA_categoryList,
  ),
];
