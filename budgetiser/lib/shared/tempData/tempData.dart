// ignore_for_file: non_constant_identifier_names

import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/recurringData.dart';
import 'package:budgetiser/shared/dataClasses/recurringTransaction.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/dataClasses/singleTransaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:flutter/material.dart';

List<Account> TMP_DATA_accountList = [
  Account(
    id: 1,
    name: "Cash",
    icon: Icons.attach_money,
    balance: 0,
    color: Colors.green,
    description: "Cash in my portemonnaie",
  ),
  Account(
    id: 2,
    name: "Credit Card",
    icon: Icons.credit_card,
    balance: 0,
    color: Colors.yellow,
    description: "Not booked credit card transactions",
  ),
  Account(
    id: 3,
    name: "Giro",
    icon: Icons.account_balance,
    balance: 0,
    color: Colors.redAccent,
    description: "Default account",
  ),
];

List<Group> TMP_DATA_groupList = [
  Group(
    id: 1,
    name: "Transportation",
    icon: Icons.emoji_transportation,
    color: Colors.green,
    description: "All transportation summarized",
    transactionCategories: [
      TMP_DATA_categoryList[0],
      TMP_DATA_categoryList[1],
      TMP_DATA_categoryList[3],
    ],
  ),
];

List<TransactionCategory> TMP_DATA_categoryList = [
  TransactionCategory(
      id: 1,
      name: "Flight Tickets",
      icon: Icons.airplane_ticket,
      color: Colors.red,
      description: "",
      isHidden: false),
  TransactionCategory(
      id: 2,
      name: "Car fuel",
      icon: Icons.local_gas_station,
      color: Colors.blue,
      description: "",
      isHidden: false),
  TransactionCategory(
      id: 3,
      name: "Shopping",
      icon: Icons.shopping_bag_outlined,
      color: Colors.green,
      description: "clothes",
      isHidden: false),
  TransactionCategory(
      id: 4,
      name: "Public transportation",
      icon: Icons.train,
      color: Colors.orange,
      description: "",
      isHidden: false),
  TransactionCategory(
      id: 5,
      name: "Bills",
      icon: Icons.receipt,
      color: Colors.purple,
      description: "",
      isHidden: false),
  TransactionCategory(
      id: 6,
      name: "Other",
      icon: Icons.more,
      color: Colors.grey,
      description: "",
      isHidden: false),
  TransactionCategory(
      id: 7,
      name: "Sports",
      icon: Icons.sports,
      color: Colors.red,
      description: "",
      isHidden: false),
  TransactionCategory(
      id: 8,
      name: "Pay check",
      icon: Icons.payments_outlined,
      color: Colors.green,
      description: "all incoming",
      isHidden: false),
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
    name: "new pc",
    icon: Icons.computer,
    color: Colors.red,
    description: "",
    balance: 1728.0,
    endDate: DateTime(2022, 10, 7),
    goal: 2000.0,
    startDate: DateTime(2022, 03, 01),
  ),
  Savings(
    id: 2,
    name: "new camera",
    icon: Icons.camera_alt,
    color: Colors.blue,
    description: "",
    balance: 0.0,
    endDate: DateTime(2022, 08, 01),
    goal: 1000.0,
    startDate: DateTime(2022, 06, 01),
  ),
  Savings(
    id: 4,
    name: "other",
    icon: Icons.more,
    color: Colors.orange,
    description: "",
    balance: 150.0,
    endDate: DateTime(2022, 04, 2),
    goal: 300.0,
    startDate: DateTime(2022, 02, 2),
  ),
];

List<Budget> TMP_DATA_budgetList = [
  Budget(
    id: 1,
    name: "shopping",
    icon: Icons.shopping_bag_outlined,
    color: Colors.red,
    description: "",
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
    name: "transportation",
    icon: Icons.emoji_transportation,
    color: Colors.blue,
    description: "",
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
    name: "house",
    icon: Icons.home,
    color: Colors.green,
    description: "",
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
    name: "other",
    icon: Icons.more,
    color: Colors.orange,
    description: "",
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
    name: "sports",
    icon: Icons.more,
    color: Colors.orange,
    description: "",
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

List<RecurringTransaction> TMP_DATA_recurringTransactionList = [
  RecurringTransaction(
    id: 1,
    title: "paycheck",
    value: 27000,
    description: "paycheck",
    category: TMP_DATA_categoryList[7],
    account: TMP_DATA_accountList[2],
    startDate: DateTime(2020, 10, 01),
    endDate: DateTime(2023, 10, 1),
    intervalAmount: 3,
    intervalUnit: IntervalUnit.month,
    intervalType: IntervalType.fixedInterval,
    repetitionAmount: 3,
  ),
  RecurringTransaction(
    id: 2,
    title: "rent",
    value: -670,
    description: "",
    category: TMP_DATA_categoryList[4],
    account: TMP_DATA_accountList[2],
    startDate: DateTime(2020, 05, 30),
    endDate: DateTime(2023, 05, 30),
    intervalAmount: 1,
    intervalUnit: IntervalUnit.month,
    intervalType: IntervalType.fixedInterval,
    repetitionAmount: 36,
  ),
];
