import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';

abstract class DemoDataset {
  List<Account> generateAccounts();
  List<TransactionCategory> generateCategories();
  List<Budget> generateBudgets();
  List<SingleTransaction> generateTransactions();
}
