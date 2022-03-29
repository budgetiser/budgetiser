import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';

class _Transaction {
  int ID;
  String title;
  int value;
  TransactionCategory category;
  Account account;
  Account account2;
  String description;

  _Transaction({
    required this.ID,
    required this.title,
    required this.value,
    required this.category,
    required this.account,
    required this.account2,
    required this.description,
  });

  // String get getTitle => title;
  // int get getValue => value;
  // Account get getAccount => account;
  // TransactionCategory get getCategory => category;
  // String get getDescription => description;
  // DateTime get getDate => date;
}
