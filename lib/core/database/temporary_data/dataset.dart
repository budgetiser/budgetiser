import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/temporary_data/datasets/beautiful.dart';
import 'package:budgetiser/core/database/temporary_data/datasets/hierarchic_categories.dart';
import 'package:budgetiser/core/database/temporary_data/datasets/old.dart';
import 'package:budgetiser/core/database/temporary_data/datasets/performance_test.dart';

abstract class DemoDataset {
  List<Account> getAccounts();
  List<TransactionCategory> getCategories();
  List<Budget> getBudgets();
  List<SingleTransaction> getTransactions();
}

List<DemoDataset> allDataSets = [
  OldDataset(),
  HierarchicDataset(),
  PerformanceTestDataset(),
  BeautifulDataset(),
];
