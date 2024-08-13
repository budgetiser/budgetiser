import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/temporary_data/dataset.dart';

class BeautifulDataset extends DemoDataset {
  @override
  List<Account> getAccounts() {
    // TODO: implement generateAccounts
    throw UnimplementedError();
  }

  @override
  List<Budget> getBudgets() {
    // TODO: implement generateBudgets
    throw UnimplementedError();
  }

  @override
  List<TransactionCategory> getCategories() {
    // TODO: implement generateCategories
    throw UnimplementedError();
  }

  @override
  List<SingleTransaction> getTransactions() {
    // TODO: implement generateTransactions
    throw UnimplementedError();
  }
}
