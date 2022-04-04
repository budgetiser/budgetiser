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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Savings",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: SingleChildScrollView(
          child: Column(
            children:  [
              for (var saving in TMP_DATA_savingsList)
                SavingItem(
                  savingData: saving,
                ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        tooltip: "New Budget",
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewSaving())
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}