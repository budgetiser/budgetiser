// ignore_for_file: non_constant_identifier_names, prefer_single_quotes

import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:budgetiser/shared/dataClasses/recurring_data.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/dataClasses/single_transaction.dart';
import 'package:budgetiser/shared/dataClasses/transaction_category.dart';
import 'package:flutter/material.dart';

List<Account> TMP_DATA_accountList = [
  Account(
    id: 1,
    name: "Cash",
    icon: Icons.attach_money,
    balance: 0,
    color: Colors.green,
    description: "Cash in my wallet",
  ),
  Account(
    id: 2,
    name: "Checking Account",
    icon: Icons.account_balance,
    balance: 1000.00,
    color: Colors.blue,
    description: "Primary checking account",
  ),
  Account(
    id: 3,
    name: "Savings Account",
    icon: Icons.account_balance,
    balance: 5000.00,
    color: Colors.orange,
    description: "Emergency savings account",
  ),
  Account(
    id: 4,
    name: "Credit Card",
    icon: Icons.credit_card,
    balance: -250.00,
    color: Colors.red,
    description: "Credit card debt",
  ),
  Account(
    id: 5,
    name: "Investment Portfolio",
    icon: Icons.pie_chart,
    balance: 25000.00,
    color: Colors.purple,
    description: "Long-term investment portfolio",
  )
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
      isHidden: false
  ),
  TransactionCategory(
      id: 2,
      name: "Groceries",
      icon: Icons.shopping_cart,
      color: Colors.green,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 3,
      name: "Restaurant",
      icon: Icons.restaurant,
      color: Colors.orange,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 4,
      name: "Utilities",
      icon: Icons.flash_on,
      color: Colors.blue,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 5,
      name: "Transportation",
      icon: Icons.directions_car,
      color: Colors.yellow,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 6,
      name: "Entertainment",
      icon: Icons.movie,
      color: Colors.purple,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 7,
      name: "Healthcare",
      icon: Icons.local_hospital,
      color: Colors.teal,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 8,
      name: "Education",
      icon: Icons.school,
      color: Colors.indigo,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 9,
      name: "Shopping",
      icon: Icons.shopping_bag,
      color: Colors.brown,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 10,
      name: "Charity",
      icon: Icons.favorite,
      color: Colors.pink,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 11,
      name: "Rent",
      icon: Icons.home,
      color: Colors.deepPurple,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 12,
      name: "Insurance",
      icon: Icons.security,
      color: Colors.amber,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 13,
      name: "Gym Membership",
      icon: Icons.fitness_center,
      color: Colors.cyan,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 14,
      name: "Vacation",
      icon: Icons.beach_access,
      color: Colors.deepOrange,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 15,
      name: "Gifts",
      icon: Icons.card_giftcard,
      color: Colors.lime,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 16,
      name: "Home Improvement",
      icon: Icons.build,
      color: Colors.blueGrey,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 17,
      name: "Subscriptions",
      icon: Icons.subscriptions,
      color: Colors.pinkAccent,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 18,
      name: "Car Maintenance",
      icon: Icons.car_repair,
      color: Colors.tealAccent,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 19,
      name: "Pet Expenses",
      icon: Icons.pets,
      color: Colors.greenAccent,
      description: "",
      isHidden: false
  ),
  TransactionCategory(
      id: 20,
      name: "Taxes",
      icon: Icons.monetization_on,
      color: Colors.deepOrangeAccent,
      description: "",
      isHidden: false
  )
];

List<SingleTransaction> TMP_DATA_transactionList = [
  SingleTransaction(
      id: 2,
      title: "Grocery Shopping",
      value: -75.60,
      category: TMP_DATA_categoryList[1],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 6, 3),
      description: "Weekly groceries"
  ),
  SingleTransaction(
      id: 3,
      title: "Dinner at Italian Restaurant",
      value: -50.00,
      category: TMP_DATA_categoryList[2],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 6, 15),
      description: "Celebrating anniversary"
  ),
  SingleTransaction(
      id: 4,
      title: "Electricity Bill",
      value: -85.20,
      category: TMP_DATA_categoryList[10],
      account: TMP_DATA_accountList[2],
      date: DateTime(2022, 6, 20),
      description: "Monthly utility bill"
  ),
  SingleTransaction(
      id: 5,
      title: "Gasoline",
      value: -40.00,
      category: TMP_DATA_categoryList[4],
      account: TMP_DATA_accountList[3],
      date: DateTime(2022, 6, 25),
      description: "Refueling the car"
  ),
  SingleTransaction(
      id: 6,
      title: "Movie Tickets",
      value: -30.00,
      category: TMP_DATA_categoryList[5],
      account: TMP_DATA_accountList[2],
      date: DateTime(2022, 6, 28),
      description: "Watching a new release"
  ),
  SingleTransaction(
      id: 7,
      title: "Doctor's Appointment",
      value: -150.00,
      category: TMP_DATA_categoryList[6],
      account: TMP_DATA_accountList[1],
      date: DateTime(2022, 7, 5),
      description: "Routine check-up"
  ),
  SingleTransaction(
      id: 8,
      title: "Textbook Purchase",
      value: -80.00,
      category: TMP_DATA_categoryList[7],
      account: TMP_DATA_accountList[1],
      date: DateTime(2022, 7, 10),
      description: "Required textbook for course"
  ),
  SingleTransaction(
      id: 9,
      title: "Online Shopping",
      value: -120.50,
      category: TMP_DATA_categoryList[8],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 7, 15),
      description: "New clothing items"
  ),
  SingleTransaction(
      id: 10,
      title: "Charitable Donation",
      value: -50.00,
      category: TMP_DATA_categoryList[9],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 7, 20),
      description: "Supporting a local charity"
  ),
  SingleTransaction(
      id: 11,
      title: "Rent Payment",
      value: -1000.00,
      category: TMP_DATA_categoryList[10],
      account: TMP_DATA_accountList[2],
      date: DateTime(2022, 7, 30),
      description: "Monthly rent for apartment"
  ),
  SingleTransaction(
      id: 12,
      title: "Car Insurance Premium",
      value: -150.00,
      category: TMP_DATA_categoryList[11],
      account: TMP_DATA_accountList[3],
      date: DateTime(2022, 8, 5),
      description: "Renewing car insurance"
  ),
  SingleTransaction(
      id: 13,
      title: "Gym Membership Fee",
      value: -50.00,
      category: TMP_DATA_categoryList[12],
      account: TMP_DATA_accountList[3],
      date: DateTime(2022, 8, 10),
      description: "Monthly gym membership fee"
  ),
  SingleTransaction(
      id: 14,
      title: "Hotel Booking",
      value: -200.00,
      category: TMP_DATA_categoryList[13],
      account: TMP_DATA_accountList[1],
      date: DateTime(2022, 8, 20),
      description: "Booking accommodation for vacation"
  ),
  SingleTransaction(
      id: 15,
      title: "Birthday Gift",
      value: -30.00,
      category: TMP_DATA_categoryList[14],
      account: TMP_DATA_accountList[4],
      date: DateTime(2022, 8, 25),
      description: "Gift for a friend's birthday"
  ),
  SingleTransaction(
      id: 16,
      title: "Home Improvement Supplies",
      value: -80.00,
      category: TMP_DATA_categoryList[15],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 8, 28),
      description: "Purchasing supplies for DIY project"
  ),
  SingleTransaction(
      id: 17,
      title: "Streaming Subscription",
      value: -9.99,
      category: TMP_DATA_categoryList[16],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 9, 5),
      description: "Monthly subscription to a streaming service"
  ),
  SingleTransaction(
      id: 18,
      title: "Car Maintenance",
      value: -120.00,
      category: TMP_DATA_categoryList[17],
      account: TMP_DATA_accountList[0],
      date: DateTime(2023, 9, 10),
      description: "Routine car maintenance and servicing"
  ),
  SingleTransaction(
      id: 19,
      title: "Pet Food and Supplies",
      value: -50.00,
      category: TMP_DATA_categoryList[18],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 9, 15),
      description: "Restocking pet food and supplies"
  ),
  SingleTransaction(
      id: 20,
      title: "Tax Payment",
      value: -500.00,
      category: TMP_DATA_categoryList[19],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 9, 20),
      description: "Quarterly tax payment"
  ),
  SingleTransaction(
      id: 21,
      title: "Concert Tickets",
      value: -80.00,
      category: TMP_DATA_categoryList[5],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 9, 25),
      description: "Attending a live concert"
  ),
  SingleTransaction(
      id: 22,
      title: "Prescription Medication",
      value: -30.00,
      category: TMP_DATA_categoryList[6],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 10, 1),
      description: "Refilling prescription medication"
  ),
  SingleTransaction(
      id: 23,
      title: "School Supplies",
      value: -50.00,
      category: TMP_DATA_categoryList[7],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 10, 5),
      description: "Purchasing school supplies"
  ),
  SingleTransaction(
      id: 24,
      title: "Electronics Purchase",
      value: -500.00,
      category: TMP_DATA_categoryList[8],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 10, 10),
      description: "Buying a new smartphone"
  ),
  SingleTransaction(
      id: 25,
      title: "Donation",
      value: -50.00,
      category: TMP_DATA_categoryList[9],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 10, 15),
      description: "Supporting environmental conservation"
  ),
  SingleTransaction(
      id: 26,
      title: "Internet Bill",
      value: -60.00,
      category: TMP_DATA_categoryList[3],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 10, 20),
      description: "Monthly internet service bill"
  ),
  SingleTransaction(
      id: 27,
      title: "Car Repair",
      value: -200.00,
      category: TMP_DATA_categoryList[17],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 10, 25),
      description: "Repairing car engine"
  ),
  SingleTransaction(
      id: 28,
      title: "Pet Grooming",
      value: -40.00,
      category: TMP_DATA_categoryList[18],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 10, 30),
      description: "Professional grooming for pets"
  ),
  SingleTransaction(
      id: 29,
      title: "Investment Purchase",
      value: -1000.00,
      category: TMP_DATA_categoryList[15],
      account: TMP_DATA_accountList[4],
      date: DateTime(2022, 11, 5),
      description: "Investing in stocks"
  ),
  SingleTransaction(
      id: 30,
      title: "Home Insurance Premium",
      value: -150.00,
      category: TMP_DATA_categoryList[11],
      account: TMP_DATA_accountList[0],
      date: DateTime(2022, 11, 10),
      description: "Renewing home insurance policy"
  )
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
    name: "Entertainment",
    icon: Icons.movie_creation_outlined,
    color: Colors.green,
    description: "",
    balance: 75.0,
    intervalRepetitions: 30,
    endDate: DateTime(2022, 01, 1).add(const Duration(days: 24 * 30)),
    startDate: DateTime(2022, 01, 1),
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
    name: "Transportation",
    icon: Icons.emoji_transportation,
    color: Colors.blue,
    description: "",
    balance: 0.0,
    intervalRepetitions: 3,
    endDate: DateTime(2022, 01, 1).add(const Duration(days: 3 * 365)),
    startDate: DateTime(2022, 01, 01),
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
    name: "Housing",
    icon: Icons.home,
    color: Colors.green,
    description: "",
    balance: 0.0,
    startDate: DateTime(2022, 01, 1),
    isRecurring: false,
    limit: 500,
    transactionCategories: [
      TMP_DATA_categoryList[3],
      TMP_DATA_categoryList[10],
      TMP_DATA_categoryList[15],
    ],
  ),
  Budget(
    id: 4,
    name: "Others",
    icon: Icons.account_balance_wallet,
    color: Colors.red,
    description: "",
    balance: 0,
    startDate: DateTime(2022, 01, 1),
    isRecurring: false,
    limit: 1500,
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
