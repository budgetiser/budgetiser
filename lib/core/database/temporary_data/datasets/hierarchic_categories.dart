import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/models/budget.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/models/transaction.dart';
import 'package:budgetiser/core/database/temporary_data/dataset.dart';
import 'package:flutter/material.dart';

class HierarchicDataset extends DemoDataset {
  static final HierarchicDataset _instance = HierarchicDataset._internal();

  /// Dataset uses singleton
  factory HierarchicDataset() {
    return _instance;
  }
  HierarchicDataset._internal() {
    categoryList = generateCategories();
  }
  late List<TransactionCategory> categoryList;
  @override
  List<Account> getAccounts() {
    return [];
  }

  @override
  List<Budget> getBudgets() {
    return [];
  }

  @override
  List<TransactionCategory> getCategories() {
    return categoryList;
  }

  @override
  List<SingleTransaction> getTransactions() {
    return [];
  }

  List<TransactionCategory> generateCategories() {
    Map<int, dynamic> linkTree = {
      1: [2, 3, 4, 5, 6, 7],
      8: {
        9: {
          10: {
            11: [12, 13, 14, 15, 16],
          }
        }
      }
    };
    List<TransactionCategory> list = [];

    int id = 1;
    void addCategory(String name, IconData icon) {
      list.add(
        TransactionCategory(
            id: id,
            name: name,
            icon: icon,
            color: Colors.green,
            description: '',
            archived: false,
            parentID: findParentKey(linkTree, id)),
      );
      id++;
    }

    // 0-6
    addCategory('Salary', Icons.attach_money);
    addCategory('Business Income', Icons.business);
    addCategory('Commissions', Icons.trending_up);
    addCategory('Investments', Icons.trending_up);
    addCategory('Money Gifts', Icons.card_giftcard);
    addCategory('Side Gigs', Icons.work);
    addCategory('Private Sellings', Icons.shopping_bag);
    // 7-11
    addCategory('Gas', Icons.local_gas_station);
    addCategory('Parking', Icons.local_parking);
    addCategory('Car Maintenance', Icons.car_repair);
    addCategory('Public Transports', Icons.directions_bus);
    addCategory('Bike', Icons.directions_bike);
    // 12-16
    addCategory('Workshops', Icons.event);
    addCategory('Conferences', Icons.event);
    addCategory('Courses', Icons.school);
    addCategory('Coaching', Icons.group);
    addCategory('Books', Icons.menu_book);
    return list;
  }

  int? findParentKey(Map<int, dynamic> map, int id) {
    for (var entry in map.entries) {
      var key = entry.key;
      var value = entry.value;

      if (value is List && value.contains(id)) {
        return key;
      } else if (value is Map<int, dynamic>) {
        if (value.containsKey(id)) {
          return key;
        } else {
          var result = findParentKey(value, id);
          if (result != null) {
            return result;
          }
        }
      } else if (value is int && value == id) {
        return key;
      }
    }
    return null;
  }
}
