import 'package:budgetiser/core/database/database.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/database/provider/budget_provider.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/core/database/provider/transaction_provider.dart';
import 'package:budgetiser/core/database/temporary_data/datasets/old.dart';
import 'package:budgetiser/shared/utils/color_utils.dart';
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
    await dbh.fillDBwithTMPdata(OldDataset());
  });
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  test('Test JSON Ex- and Import', () async {
    var fullJSON1 = await dbh.generateRobustJSON();

    await dbh.importJSONdata(fullJSON1);

    await dbh.resetDB();
    await dbh.fillDBwithTMPdata(OldDataset());

    for (Account a in OldDataset().getAccounts()) {
      // cant check balance, because it is changed in the db after inserting transactions
      expect(a.name, (await AccountModel().getOneAccount(a.id)).name);
      expect(
        a.description,
        (await AccountModel().getOneAccount(a.id)).description,
      );

      // comparing int32 values, because one object is a MaterialColor and the other is a Color
      var a123 = (await AccountModel().getOneAccount(a.id)).color;
      expect(ColorEx(a.color).toInt32, ColorEx(a123).toInt32);

      expect(
        a.icon.toString(),
        (await AccountModel().getOneAccount(a.id)).icon.toString(),
      );
      expect(a.archived, (await AccountModel().getOneAccount(a.id)).archived);
    }

    for (SingleTransaction t in OldDataset().getTransactions()) {
      expect(
        t.toString(),
        (await TransactionModel().getOneTransaction(t.id)).toString(),
      );
    }
    for (Budget b in OldDataset().getBudgets()) {
      expect(b.toString(), (await BudgetModel().getBudget(b.id)).toString());
    }
    for (TransactionCategory t in OldDataset().getCategories()) {
      expect(
        t.toString(),
        (await CategoryModel().getCategory(t.id)).toString(),
      );
    }

    var fullJSON2 = await dbh.generateRobustJSON();
    expect(fullJSON1, fullJSON2);
  });

  test('Test JSON Im- and Export', () async {
    var json = {
      'account': [
        {
          'id': 1,
          'name': 'Wallet',
          'icon': 985044,
          'color': 4283215696,
          'balance': -336.41,
          'description': '',
          'archived': 0,
        },
        {
          'id': 2,
          'name': 'Card',
          'icon': 985044,
          'color': 4283215696,
          'balance': 0.0,
          'description': '',
          'archived': 1,
        }
      ],
      'budget': [
        {
          'id': 1,
          'name': 'shopping',
          'icon': 62333,
          'color': 4294198070,
          'max_value': 100.0,
          'interval_unit': 'IntervalUnit.month',
          'description': '',
        },
      ],
      'category': [
        {
          'id': 1,
          'name': 'Salary',
          'icon': 57522,
          'color': 4280391411,
          'description': '',
          'archived': 0,
        },
        {
          'id': 2,
          'name': 'Business Income',
          'icon': 57627,
          'color': 4294198070,
          'description': '',
          'archived': 0,
        },
        {
          'id': 3,
          'name': 'Other Income',
          'icon': 57627,
          'color': 4294198070,
          'description': '',
          'archived': 1,
        },
      ],
      'categoryBridge': [
        {
          'parent_id': 1,
          'child_id': 1,
          'distance': 0,
        },
        {
          'parent_id': 2,
          'child_id': 2,
          'distance': 0,
        },
        {
          'parent_id': 3,
          'child_id': 3,
          'distance': 0,
        },
        {
          'parent_id': 2,
          'child_id': 3,
          'distance': 1,
        },
      ],
      'categoryToBudget': [
        {
          'category_id': 1,
          'budget_id': 1,
        },
      ],
      'singleTransaction': [
        {
          'id': 1,
          'title': 'snacks',
          'value': -2.0,
          'description': null,
          'category_id': 1,
          'date': 1721983891492,
          'account1_id': 1,
          'account2_id': null,
        },
        {
          'id': 2,
          'title': 'gambling',
          'value': 200.0,
          'description': '',
          'category_id': 1,
          'date': 1719391891492,
          'account1_id': 2,
          'account2_id': 1,
        },
        {
          'id': 3,
          'title': 'Monthly Salary',
          'value': 2500.0,
          'description': '',
          'category_id': 1,
          'date': 1716799891492,
          'account1_id': 2,
          'account2_id': null,
        },
      ],
    };
    // for some reason this transaction list order works

    await dbh.importJSONdata(json);

    var exportedJson = await dbh.generateRobustJSON();

    expect(json.toString(), exportedJson.toString());
  });
}
