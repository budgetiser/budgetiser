import 'package:budgetiser/screens/savings/newSaving.dart';
import 'package:budgetiser/screens/savings/shared/savingItem.dart';
import 'package:flutter/material.dart';
import '../../shared/tempData/tempData.dart';
import '../../shared/widgets/drawer.dart';

class Savings extends StatelessWidget {
  static String routeID = 'savings';

  Savings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            children:  [
              for (var saving in TMP_DATA_savingsList)
                SavingItem(
                  savingData: saving,
                ),
            ],
          ),
        );
  }
}