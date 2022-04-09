import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/dataClasses/transaction.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:flutter/material.dart';

List<Account> TMP_DATA_accountList = [
  Account(
    id: 1,
    name: "Cash",
    icon: Icons.attach_money,
    balance: 10,
    color: Colors.green,
    description: "account cash description",
  ),
  Account(
    id: 2,
    name: "Credit Card",
    icon: Icons.credit_card,
    balance: -500,
    color: Colors.blue,
    description: "account credit card description",
  ),
  Account(
    id: 3,
    name: "Bank Account long name",
    icon: Icons.account_balance_wallet,
    balance: 1230,
    color: Colors.orange,
    description: "account bank description",
  ),
  Account(
    id: 4,
    name: "Savings",
    icon: Icons.account_balance_wallet,
    balance: 681.82,
    color: Colors.purple,
    description: "account savings description",
  ),
];

List<Group> TMP_DATA_groupList = [
  Group(
    id: 1,
    name: "Group 1",
    icon: Icons.group,
    color: Colors.green,
    description: "group 1 description",
    transactionCategories: [
      TMP_DATA_categoryList[1],
      TMP_DATA_categoryList[2],
      TMP_DATA_categoryList[3],
    ],
  ),
  Group(
    id: 2,
    name: "Group 2",
    icon: Icons.group,
    color: Colors.blue,
    description: "group 2 description",
    transactionCategories: [
      TMP_DATA_categoryList[4],
      TMP_DATA_categoryList[0],
    ],
  ),
  Group(
    id: 3,
    name: "Group 3",
    icon: Icons.group,
    color: Colors.orange,
    description: "group 3 description",
    transactionCategories: [
      TMP_DATA_categoryList[5],
      TMP_DATA_categoryList[6],
      TMP_DATA_categoryList[7],
    ],
  ),
];

List<TransactionCategory> TMP_DATA_categoryList = [
  TransactionCategory(
      id: 2,
      name: "Food",
      icon: Icons.fastfood,
      color: Colors.red,
      description: "category food description",
      isHidden: false),
  TransactionCategory(
      id: 1,
      name: "Entertainment",
      icon: Icons.local_movies,
      color: Colors.blue,
      description: "category entertainment description",
      isHidden: false),
  TransactionCategory(
      id: 3,
      name: "Shopping",
      icon: Icons.shopping_cart,
      color: Colors.green,
      description: "category shopping description",
      isHidden: false),
  TransactionCategory(
      id: 4,
      name: "Transport",
      icon: Icons.directions_car,
      color: Colors.orange,
      description: "category transport description",
      isHidden: false),
  TransactionCategory(
      id: 5,
      name: "Bills",
      icon: Icons.receipt,
      color: Colors.purple,
      description: "category bills description",
      isHidden: false),
  TransactionCategory(
      id: 6,
      name: "Other",
      icon: Icons.more,
      color: Colors.grey,
      description: "category other description",
      isHidden: false),
  TransactionCategory(
      id: 7,
      name: "Health",
      icon: Icons.local_hospital,
      color: Colors.red,
      description: "category health description",
      isHidden: false),
];

List<Transaction> TMP_DATA_transactionList = [
  SingleTransaction(
    id: 1,
    title: 'birthday present',
    value: -15.0,
    category: TMP_DATA_categoryList[2],
    account: TMP_DATA_accountList[0],
    date: DateTime(2020, 1, 1),
    description: 'for max mustermann',
  ),
  SingleTransaction(
    id: 2,
    title: 'cinema ticket',
    value: -13.89,
    category: TMP_DATA_categoryList[1],
    account: TMP_DATA_accountList[3],
    date: DateTime(2021, 10, 9),
    description: 'with friends',
  ),
  RecurringTransaction(
    id: 3,
    title: 'weekly groceries',
    value: -40,
    category: TMP_DATA_categoryList[0],
    account: TMP_DATA_accountList[1],
    startDate: DateTime(2043, 1, 2),
    endDate: DateTime(1999, 9, 1),
    intervalType: 'Days',
    intervalAmount: 1,
    intervalUnit: 'Days',
    description: 'at the supermarket',
  ),
  RecurringTransaction(
    id: 4,
    title: 'car insurance',
    value: 123,
    category: TMP_DATA_categoryList[3],
    account: TMP_DATA_accountList[1],
    startDate: DateTime(2020, 1, 1),
    endDate: DateTime(2099, 9, 9),
    intervalType: 'Months',
    intervalAmount: 1,
    intervalUnit: 'Months',
    description: 'Test description',
  ),
  RecurringTransaction(
    id: 5,
    title: 'rent',
    value: 1000.0,
    category: TMP_DATA_categoryList[3],
    account: TMP_DATA_accountList[2],
    startDate: DateTime(2020, 1, 1),
    endDate: DateTime(2030, 1, 1),
    intervalType: 'Months',
    intervalAmount: 1,
    intervalUnit: 'Years',
    description: '',
  ),
  RecurringTransaction(
    id: 6,
    title: 'savings',
    value: 59,
    category: TMP_DATA_categoryList[4],
    account: TMP_DATA_accountList[3],
    account2: TMP_DATA_accountList[0],
    startDate: DateTime(2021, 2, 4),
    endDate: DateTime(2022, 2, 4),
    intervalType: 'Months',
    intervalAmount: 1,
    intervalUnit: 'Months',
    description: 'at the bank',
  ),
  SingleTransaction(
    id: 7,
    title: 'lunch',
    value: -69,
    category: TMP_DATA_categoryList[5],
    account: TMP_DATA_accountList[0],
    date: DateTime.now(),
    description: 'steak',
  ),
  SingleTransaction(
    id: 8,
    title: 'coffee',
    value: -10.0,
    category: TMP_DATA_categoryList[6],
    account: TMP_DATA_accountList[2],
    date: DateTime(2021, 1, 1),
    description: 'at work',
  ),
  SingleTransaction(
    id: 9,
    title: 'health insurance',
    value: -810.0,
    category: TMP_DATA_categoryList[0],
    account: TMP_DATA_accountList[1],
    date: DateTime.now(),
    description: 'teeth',
  ),
  SingleTransaction(
    id: 10,
    title: 'dinner',
    value: -35.0,
    category: TMP_DATA_categoryList[2],
    account: TMP_DATA_accountList[0],
    date: DateTime.now(),
    description: 'with friends',
  ),
];

List<Savings> TMP_DATA_savingsList = [
  Savings(
    id: 1,
    name: "pc building",
    icon: Icons.computer,
    color: Colors.red,
    description: "savings pc description",
    balance: 100.0,
    endDate: DateTime(2022, 10, 7),
    goal: 1200.0,
    startDate: DateTime(2020, 10, 2),
  ),
  Savings(
    id: 2,
    name: "car",
    icon: Icons.directions_car,
    color: Colors.blue,
    description: "savings car description",
    balance: 100.0,
    endDate: DateTime(2022, 10, 8),
    goal: 1200.0,
    startDate: DateTime(2020, 10, 2),
  ),
  Savings(
    id: 3,
    name: "house",
    icon: Icons.home,
    color: Colors.green,
    description: "savings house description",
    balance: 800.0,
    endDate: DateTime(2022, 12, 13),
    goal: 1200.0,
    startDate: DateTime(2020, 10, 2),
  ),
  Savings(
    id: 4,
    name: "other",
    icon: Icons.more,
    color: Colors.orange,
    description: "savings other description",
    balance: 10.0,
    endDate: DateTime(2023, 01, 2),
    goal: 300.0,
    startDate: DateTime(2020, 10, 2),
  ),
];

List<Budget> TMP_DATA_budgetList = [
  Budget(
    id: 1,
    name: "pc building",
    icon: Icons.computer,
    color: Colors.red,
    description: "budget pc description",
    balance: 100.0,
    endDate: DateTime(2022, 10, 2),
    startDate: DateTime(2020, 10, 2),
    intervalAmount: 3,
    intervalUnit: 'Months',
    intervalType: 'isTheXofUnit',
    isRecurring: true,
    limit: 500,
    transactionCategories: [
      TMP_DATA_categoryList[0],
      TMP_DATA_categoryList[1],
    ],
  ),
  Budget(
    id: 2,
    name: "car",
    icon: Icons.directions_car,
    color: Colors.blue,
    description: "budget car description",
    balance: 100.0,
    endDate: DateTime(2023, 2, 2),
    startDate: DateTime(2020, 7, 21),
    intervalAmount: 3,
    intervalUnit: 'Days',
    intervalType: 'isTheXofUnit',
    isRecurring: true,
    limit: 500,
    transactionCategories: [
      TMP_DATA_categoryList[4],
      TMP_DATA_categoryList[1],
    ],
  ),
  Budget(
    id: 3,
    name: "house",
    icon: Icons.home,
    color: Colors.green,
    description: "budget house description",
    balance: 400.0,
    endDate: DateTime(2022, 10, 2),
    startDate: DateTime(2020, 10, 2),
    intervalAmount: 3,
    intervalUnit: 'Months',
    intervalType: 'isTheXofUnit',
    isRecurring: false,
    limit: 500,
    transactionCategories: [
      TMP_DATA_categoryList[0],
      TMP_DATA_categoryList[1],
    ],
  ),
  Budget(
    id: 4,
    name: "other",
    icon: Icons.more,
    color: Colors.orange,
    description: "budget other description",
    balance: 10.0,
    endDate: DateTime(2022, 10, 2),
    startDate: DateTime(2020, 10, 2),
    intervalAmount: 3,
    intervalUnit: 'Months',
    intervalType: 'isTheXofUnit',
    isRecurring: true,
    limit: 500,
    transactionCategories: [
      TMP_DATA_categoryList[0],
      TMP_DATA_categoryList[1],
    ],
  ),
];
