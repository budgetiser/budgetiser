// ignore_for_file: non_constant_identifier_names

import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/recurring_data.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:flutter/material.dart';

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
        id: i,
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

List<TransactionCategory> getCategoriesAndGroups() {
  List<TransactionCategory> categories = [];
  List<IconData> icons = [];
  List<String> names = [];
  List<Color> colors = [];

  names.add('Salary');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Business Income');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Commissions');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Investments');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Money Gifts');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Side Gigs');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Private Sellings');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Gas');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Parking');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Car Maintenance');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Public Transports');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Bike');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Workshops');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Conferences');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Courses');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Coaching');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Books');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Doctor Bills');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Hospital Bills');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Dentist');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Medical Devices');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Cinema');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Theater');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Subscriptions');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Memberships');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Hobbies');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Rent');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Property Taxes');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Home Repairs');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Gardening');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Groceries');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Take Aways');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Snacks');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Daycare');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Extracurricular Activities');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Life Insurances');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Home Insurances');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Car Insurances');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Business Insurances');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Birthday Gifts');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Holiday Gifts');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Donations');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Electricity Bill');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Water Bill');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Heat Bill');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Internet Bill');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Phone Billings');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Beauty');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Hygiene');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Grooming');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('SPA');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Clothing');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Pet Food');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Veterinary Bills');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Pet Training');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  names.add('Car Debt');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('Personal Loans');
  icons.add(Icons.cases);
  colors.add(Colors.green);
  names.add('House debt');
  icons.add(Icons.cases);
  colors.add(Colors.green);

  for (int i = 0; i < icons.length; i++) {
    categories.add(TransactionCategory(
        id: i,
        name: names[i],
        icon: icons[i],
        color: colors[i],
        description: '',
        isHidden: false));
  }
  return categories;
}

List<TransactionCategory> TMP_DATA_categoryList = getCategoriesAndGroups();

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
