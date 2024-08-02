import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';

abstract class DemoDataset {
  List<Account> getAccounts();
  List<TransactionCategory> getCategories();
  List<Budget> getBudgets();
  List<SingleTransaction> getTransactions();
}
