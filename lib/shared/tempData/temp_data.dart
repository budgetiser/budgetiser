// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/recurring_data.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
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
  List<Color> colors = [
    Colors.brown,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.blue,
    Colors.yellow
  ];

  for (int i = 0; i < icons.length; i++) {
    accounts.add(
      Account(
        id: i + 1,
        name: names[i],
        icon: icons[i],
        color: colors[i],
        balance: 0.0,
        description: '',
      ),
    );
  }

  return accounts;
}

List<Account> TMP_DATA_accountList = getExampleAccounts();

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
        isHidden: false,
      ),
    );
    id++;
  }

  addCategory('Snacks', Icons.fastfood);
  addCategory('Salary', Icons.attach_money);
  addCategory('Business Income', Icons.business);
  addCategory('Commissions', Icons.trending_up);
  addCategory('Investments', Icons.trending_up);
  addCategory('Money Gifts', Icons.card_giftcard);
  addCategory('Side Gigs', Icons.work);
  addCategory('Private Sellings', Icons.shopping_bag);

  addCategory('Gas', Icons.local_gas_station);
  addCategory('Parking', Icons.local_parking);
  addCategory('Car Maintenance', Icons.car_repair);
  addCategory('Public Transports', Icons.directions_bus);
  addCategory('Bike', Icons.directions_bike);

  addCategory('Workshops', Icons.event);
  addCategory('Conferences', Icons.event);
  addCategory('Courses', Icons.school);
  addCategory('Coaching', Icons.group);
  addCategory('Books', Icons.menu_book);

  addCategory('Doctor Bills', Icons.local_hospital);
  addCategory('Hospital Bills', Icons.local_hospital);
  addCategory('Dentist', Icons.local_hospital);
  addCategory('Medical Devices', Icons.medical_services);

  addCategory('Cinema', Icons.local_movies);
  addCategory('Theater', Icons.theaters);
  addCategory('Subscriptions', Icons.subscriptions);
  addCategory('Memberships', Icons.card_membership);
  addCategory('Hobbies', Icons.sports_esports);

  addCategory('Rent', Icons.home);
  addCategory('Property Taxes', Icons.home);
  addCategory('Home Repairs', Icons.home_repair_service);
  addCategory('Gardening', Icons.spa);

  addCategory('Groceries', Icons.shopping_cart);
  addCategory('Take Aways', Icons.food_bank);

  addCategory('Daycare', Icons.child_care);
  addCategory('Extracurricular Activities', Icons.sports_soccer);

  addCategory('Life Insurances', Icons.local_hospital);
  addCategory('Home Insurances', Icons.home);
  addCategory('Car Insurances', Icons.directions_car);
  addCategory('Business Insurances', Icons.business);

  addCategory('Birthday Gifts', Icons.card_giftcard);
  addCategory('Holiday Gifts', Icons.card_giftcard);
  addCategory('Donations', Icons.favorite);

  addCategory('Electricity Bill', Icons.flash_on);
  addCategory('Water Bill', Icons.opacity);
  addCategory('Heat Bill', Icons.whatshot);
  addCategory('Internet Bill', Icons.wifi);
  addCategory('Phone Billings', Icons.phone);

  addCategory('Beauty', Icons.spa);
  addCategory('Hygiene', Icons.spa);
  addCategory('Grooming', Icons.spa);
  addCategory('SPA', Icons.spa);
  addCategory('Clothing', Icons.shopping_bag);

  addCategory('Pet Food', Icons.pets);
  addCategory('Veterinary Bills', Icons.local_hospital);
  addCategory('Pet Training', Icons.pets);

  addCategory('Car Debt', Icons.credit_card);
  addCategory('Personal Loans', Icons.credit_card);
  addCategory('House debt', Icons.home);

  return list;
}

List<TransactionCategory> TMP_DATA_categoryList = getCategoryList();

List<Group> TMP_DATA_groupList = [
  Group(
    id: 1,
    name: 'Transportation',
    icon: Icons.emoji_transportation,
    color: Colors.green,
    description: 'All transportation summarized',
    transactionCategories: [
      TMP_DATA_categoryList[7],
      TMP_DATA_categoryList[8],
      TMP_DATA_categoryList[9],
      TMP_DATA_categoryList[10],
      TMP_DATA_categoryList[11],
    ],
  ),
];

List<SingleTransaction> getTransactionList() {
  List<SingleTransaction> list = [];
  int id = 1;
  void addTransaction(
    String title,
    double value,
    int categoryIndex,
    int accountIndex,
    int daysMinus,
    String description, {
    int? account2index,
  }) {
    list.add(
      SingleTransaction(
        id: id,
        title: title,
        value: value,
        category:
            TMP_DATA_categoryList[categoryIndex % TMP_DATA_categoryList.length],
        account:
            TMP_DATA_accountList[accountIndex % TMP_DATA_accountList.length],
        account2: account2index != null
            ? TMP_DATA_accountList[account2index % TMP_DATA_accountList.length]
            : null,
        date: DateTime.now().subtract(
          Duration(days: daysMinus),
        ),
        description: description,
      ),
    );
    id++;
  }

  addTransaction('Flight to aveiro', -400.70, 0, 2, 51, 'Portugal internship');
  addTransaction('Refuel', -120, 1, 0, 63, '');
  addTransaction('New clothes', -380, 2, 0, 35, '');
  addTransaction('Bus ticket', -206, 3, 2, 21, '');
  addTransaction('Telekom', -44.5, 4, 2, 13, '');
  addTransaction('Gym', -26.5, 6, 2, 15, '');
  addTransaction('Cafeteria', -15, 5, 0, 8, '');
  addTransaction('Mom & Dad', 200, 7, 2, 7, '');
  addTransaction('Salary', 27000, 7, 2, 5, '');
  addTransaction('Withdrawal', 1500, 5, 2, 0, '');
  addTransaction('Rental car', -480, 5, 1, 10, '');
  addTransaction('Flight to Paris', -600.85, 0, 1, 62, 'Vacation trip');
  addTransaction('New Laptop', -1200, 2, 3, 10, 'Tech upgrade');
  addTransaction('Restaurant Dinner', -80, 5, 1, 5, '');

  addTransaction('Grocery Shopping', -70, 31, 0, 5, '');
  addTransaction('Haircut', -25, 45, 2, 7, '');
  addTransaction('Movie Tickets', -40, 22, 1, 8, '');
  addTransaction('Pet Grooming', -35, 49, 4, 4, '');
  addTransaction('Gift Shop', -15, 39, 0, 6, '');
  addTransaction('Home Decor', -80, 29, 4, 9, '');
  addTransaction('Mobile Recharge', -20, 49, 1, 3, '');
  addTransaction('Fitness Class', -50, 37, 0, 2, '');
  addTransaction('Tech Accessories', -60, 32, 2, 1, '');
  addTransaction('Dinner with Friends', -90, 22, 1, 12, '');
  addTransaction('Vacation Expenses', -300, 16, 2, 11, '');
  addTransaction('Car Wash', -20, 8, 0, 14, '');
  addTransaction('Home Insurance', -120, 30, 1, 15, '');
  addTransaction('Health Checkup', -75, 17, 2, 17, '');
  addTransaction('Online Course', -50, 14, 3, 20, '');
  addTransaction('Business Trip', -250, 12, 1, 25, '');
  addTransaction('Charity Donation', -30, 40, 0, 27, '');
  addTransaction('Pet Supplies', -40, 50, 4, 30, '');
  addTransaction('Home Repairs', -120, 28, 3, 28, '');
  addTransaction('Coffee Shop', -15, 22, 1, 29, '');
  addTransaction('Subscription Renewal', -10, 23, 4, 26, '');
  addTransaction('New Phone', -500, 32, 1, 23, '');
  addTransaction('Tax Payment', -180, 27, 2, 22, '');
  addTransaction('Music Concert', -100, 22, 3, 18, '');

  addTransaction('Electricity Bill', -85, 24, 0, 27, '');
  addTransaction('Water Bill', -50, 25, 1, 27, '');
  addTransaction('Heat Bill', -70, 26, 2, 26, '');
  addTransaction('Internet Bill', -60, 28, 3, 25, '');
  addTransaction('Phone Billings', -45, 28, 0, 24, '');
  addTransaction('Beauty', -90, 44, 1, 23, '');
  addTransaction('Hygiene', -30, 45, 2, 22, '');
  addTransaction('Grooming', -20, 46, 3, 21, '');
  addTransaction('SPA', -150, 47, 0, 20, '');
  addTransaction('Clothing', -70, 48, 1, 19, '');

  addTransaction('Charge', 100, 0, 1, 40, '', account2index: 5);
  for (int i = 4; i < 30; i += 2) {
    addTransaction('Cafeteria', -Random().nextDouble() * 5, 0, 5, i, '');
  }

  return list;
}

List<SingleTransaction> TMP_DATA_transactionList = getTransactionList();

List<Savings> TMP_DATA_savingsList = [
  Savings(
    id: 1,
    name: 'new pc',
    icon: Icons.computer,
    color: Colors.red,
    description: '',
    balance: 1728.0,
    endDate: DateTime.now().add(
      const Duration(days: 50),
    ),
    goal: 2000.0,
    startDate: DateTime.now().subtract(
      const Duration(days: 4),
    ),
  ),
  Savings(
    id: 2,
    name: 'new camera',
    icon: Icons.camera_alt,
    color: Colors.blue,
    description: '',
    balance: 0.0,
    endDate: DateTime.now().add(
      const Duration(days: 32),
    ),
    goal: 1000.0,
    startDate: DateTime.now().subtract(
      const Duration(days: 40),
    ),
  ),
  Savings(
    id: 4,
    name: 'other',
    icon: Icons.more,
    color: Colors.orange,
    description: '',
    balance: 150.0,
    endDate: DateTime.now().add(
      const Duration(days: 4),
    ),
    goal: 300.0,
    startDate: DateTime.now().subtract(
      const Duration(days: 70),
    ),
  ),
];

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
      TMP_DATA_categoryList[2],
    ],
  ),
  Budget(
    id: 2,
    name: 'transportation',
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
    limit: 5000,
    transactionCategories: [
      TMP_DATA_categoryList[3],
      TMP_DATA_categoryList[0],
      TMP_DATA_categoryList[1],
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
      TMP_DATA_categoryList[5],
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
      TMP_DATA_categoryList[6],
    ],
  ),
];
