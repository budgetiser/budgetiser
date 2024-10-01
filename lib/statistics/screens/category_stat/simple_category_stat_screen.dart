import 'package:badges/badges.dart' as badges;
import 'package:budgetiser/categories/picker/category_picker.dart';
import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/shared/widgets/picker/segmented_duration_picker.dart';
import 'package:budgetiser/statistics/screens/category_stat/simple_category_stat.dart';
import 'package:flutter/material.dart';

class SimpleCategoryStatScreen extends StatefulWidget {
  const SimpleCategoryStatScreen({super.key});

  @override
  State<SimpleCategoryStatScreen> createState() =>
      _SimpleCategoryStatScreenState();
}

class _SimpleCategoryStatScreenState extends State<SimpleCategoryStatScreen> {
  List<TransactionCategory> _selectedCategories = [];
  DateTime _selectedStartDate = DateTime(2000);

  void setCategory(List<TransactionCategory> c) {
    setState(() {
      _selectedCategories = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category stats'),
        actions: [
          IconButton(
            icon: badges.Badge(
              badgeContent: Text(
                _selectedCategories.length.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              showBadge: _selectedCategories.isNotEmpty,
              child: const Icon(Icons.filter_alt_sharp),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CategoryPicker.multi(
                    onCategoryPickedCallbackMulti: setCategory,
                    initialValues: _selectedCategories,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SegmentedDurationPicker(
              callback: (newDate) {
                setState(() {
                  _selectedStartDate = newDate;
                });
              },
            ),
            Text(
              'Showing data since ${_selectedStartDate.year}-${_selectedStartDate.month}-${_selectedStartDate.day}',
            ),
            SimpleCategoryStatTables(
              categories: _selectedCategories,
              startDate: _selectedStartDate,
            ),
          ],
        ),
      ),
    );
  }
}
