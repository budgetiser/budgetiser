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
  addCategory('Snacks', Icons.fastfood);

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
      TMP_DATA_categoryList[0],
      TMP_DATA_categoryList[1],
      TMP_DATA_categoryList[3],
    ],
  ),
];

List<SingleTransaction> TMP_DATA_transactionList = [
  SingleTransaction(
    id: 1,
    title: 'flight to aveiro',
    value: -400.70,
    category: TMP_DATA_categoryList[0],
    account: TMP_DATA_accountList[2],
    date: DateTime(2022, 05, 12),
    description: 'portugal internship',
  ),
  SingleTransaction(
    id: 2,
    title: 'refuel',
    value: -120,
    category: TMP_DATA_categoryList[1],
    account: TMP_DATA_accountList[0],
    date: DateTime(2022, 05, 15),
    description: '',
  ),
  SingleTransaction(
    id: 3,
    title: 'new clothes',
    value: -380,
    category: TMP_DATA_categoryList[2],
    account: TMP_DATA_accountList[0],
    date: DateTime(2022, 05, 07),
    description: '',
  ),
  SingleTransaction(
    id: 4,
    title: 'studi ticket',
    value: -206,
    category: TMP_DATA_categoryList[3],
    account: TMP_DATA_accountList[2],
    date: DateTime(2022, 03, 01),
    description: '',
  ),
  SingleTransaction(
    id: 5,
    title: 'telekom',
    value: -44.5,
    category: TMP_DATA_categoryList[4],
    account: TMP_DATA_accountList[2],
    date: DateTime(2022, 05, 01),
    description: '',
  ),
  SingleTransaction(
    id: 6,
    title: 'gym',
    value: -26.5,
    category: TMP_DATA_categoryList[6],
    account: TMP_DATA_accountList[2],
    date: DateTime(2022, 05, 7),
    description: '',
  ),
  SingleTransaction(
    id: 7,
    title: 'cantine',
    value: -15,
    category: TMP_DATA_categoryList[5],
    account: TMP_DATA_accountList[0],
    date: DateTime(2022, 4, 30),
    description: '',
  ),
  SingleTransaction(
    id: 8,
    title: 'Mom & Dad',
    value: 200,
    category: TMP_DATA_categoryList[7],
    account: TMP_DATA_accountList[2],
    date: DateTime(2022, 5, 1),
    description: '',
  ),
  SingleTransaction(
    id: 9,
    title: 'bosch',
    value: 27000,
    category: TMP_DATA_categoryList[7],
    account: TMP_DATA_accountList[2],
    date: DateTime(2022, 4, 30),
    description: '',
  ),
  SingleTransaction(
    id: 10,
    title: 'withdrawal',
    value: 1500,
    category: TMP_DATA_categoryList[5],
    account: TMP_DATA_accountList[2],
    account2: TMP_DATA_accountList[0],
    date: DateTime(2022, 5, 1),
    description: '',
  ),
  SingleTransaction(
    id: 11,
    title: 'rental car',
    value: -480,
    category: TMP_DATA_categoryList[5],
    account: TMP_DATA_accountList[1],
    date: DateTime(2022, 5, 20),
    description: '',
  ),
];

List<Savings> TMP_DATA_savingsList = [
  Savings(
    id: 1,
    name: 'new pc',
    icon: Icons.computer,
    color: Colors.red,
    description: '',
    balance: 1728.0,
    endDate: DateTime(2022, 10, 7),
    goal: 2000.0,
    startDate: DateTime(2022, 03, 01),
  ),
  Savings(
    id: 2,
    name: 'new camera',
    icon: Icons.camera_alt,
    color: Colors.blue,
    description: '',
    balance: 0.0,
    endDate: DateTime(2022, 08, 01),
    goal: 1000.0,
    startDate: DateTime(2022, 06, 01),
  ),
  Savings(
    id: 4,
    name: 'other',
    icon: Icons.more,
    color: Colors.orange,
    description: '',
    balance: 150.0,
    endDate: DateTime(2022, 04, 2),
    goal: 300.0,
    startDate: DateTime(2022, 02, 2),
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
    endDate: DateTime(2020, 10, 1).add(const Duration(days: 30 * 30)),
    startDate: DateTime(2020, 10, 1),
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
    endDate: DateTime(2020, 01, 1).add(const Duration(days: 3 * 365)),
    startDate: DateTime(2020, 01, 01),
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
    endDate: DateTime(2022, 10, 2).add(const Duration(days: 3 * 5)),
    startDate: DateTime(2022, 10, 2),
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
    startDate: DateTime(2020, 10, 2),
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
    endDate: DateTime(2021, 01, 2),
    startDate: DateTime(2020, 10, 2),
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
