import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/budget_provider.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/core/database/temporary_data/temp_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main() {
  // Setup sqflite_common_ffi for flutter test
  late DatabaseHelper dbh;
  setUpAll(() async {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;

    var db = await openDatabase(
      inMemoryDatabasePath,
    );
    dbh = DatabaseHelper.instance..setDatabase(db);
    await dbh.resetDB();
    await dbh.fillDBwithTMPdata();
  });
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('Test JSON Ex- and Import', () async {
    var fullJSON1 = await dbh.generateJson();

    await dbh.setDatabaseContentWithJson(fullJSON1);

    await dbh.resetDB();
    await dbh.fillDBwithTMPdata();

    for (Account a in TMP_DATA_accountList) {
      // cant check balance, because it is changed in the db after inserting transactions
      expect(a.name, (await AccountModel().getOneAccount(a.id)).name);
      expect(a.description,
          (await AccountModel().getOneAccount(a.id)).description);
      expect(a.color.value,
          (await AccountModel().getOneAccount(a.id)).color.value);
      expect(a.icon.toString(),
          (await AccountModel().getOneAccount(a.id)).icon.toString());
      expect(a.archived, (await AccountModel().getOneAccount(a.id)).archived);
    }

    for (SingleTransaction t in TMP_DATA_transactionList) {
      expect(t.toString(),
          (await TransactionModel().getOneTransaction(t.id)).toString());
    }
    for (Budget b in TMP_DATA_budgetList) {
      expect(b.toString(), (await BudgetModel().getBudget(b.id)).toString());
    }
    for (TransactionCategory t in TMP_DATA_categoryList) {
      expect(
          t.toString(), (await CategoryModel().getCategory(t.id)).toString());
    }

    var fullJSON2 = await dbh.generateJson();
    expect(fullJSON1, fullJSON2);
  });

  test('Test JSON Im- and Export', () async {
    var json = {
      'Accounts': [
        {
          'name': 'Wallet',
          'icon': 985044,
          'color': 4278228616,
          'balance': -336.41,
          'description': null,
          'archived': 0,
          'id': 1
        }
      ],
      'Budgets': [
        {
          'name': 'shopping',
          'icon': 62333,
          'color': 4294198070,
          'description': null,
          'max_value': 100.0,
          'interval_unit': 'IntervalUnit.month',
          'id': 1,
          'transactionCategories': [1, 2]
        },
      ],
      'Categories': [
        {
          'name': 'Shopping',
          'icon': 57522,
          'color': 4282339765,
          'description': '',
          'archived': 0,
          'id': 1,
          'parentID': null
        },
        {
          'name': 'Leisure',
          'icon': 57627,
          'color': 4294940672,
          'description': '',
          'archived': 0,
          'id': 2,
          'parentID': null
        },
      ],
      'Transactions': [
        {
          'title': 'snacks',
          'value': -2.0,
          'description': '',
          'category_id': 1,
          'date': 1708366977679,
          'account1_id': 1,
          'account2_id': null,
          'id': 2
        },
        {
          'title': 'gambling',
          'value': -200.0,
          'description': '',
          'category_id': 2,
          'date': 1708366977672,
          'account1_id': 1,
          'account2_id': null,
          'id': 1
        },
        {
          'title': 'Groceries',
          'value': -28.75,
          'description': '',
          'category_id': 1,
          'date': 1708107778679,
          'account1_id': 1,
          'account2_id': null,
          'id': 3
        },
      ],
    };
    // for some reason this transaction list order works

    await dbh.setDatabaseContentWithJson(json);

    var exportedJson = await dbh.generateJson();

    expect(json, exportedJson);
  });
}
