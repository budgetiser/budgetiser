import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/budgets/budget_form.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/widgets/items/budget_item.dart';
import 'package:flutter/material.dart';

class Budgets extends StatefulWidget {
  static String routeID = 'budgets';

  const Budgets({Key? key}) : super(key: key);

  @override
  State<Budgets> createState() => _BudgetsState();
}

class _BudgetsState extends State<Budgets> {
  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.pushGetAllBudgetsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      drawer: const CreateDrawer(),
      body: StreamBuilder<List<Budget>>(
        stream: DatabaseHelper.instance.allBudgetsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Text('Oops!');
          }
          List<Budget> budgetList = snapshot.data!
            ..sort((a, b) => a.compareTo(b));
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: budgetList.length,
            itemBuilder: (BuildContext context, int index) {
              return BudgetItem(
                budgetData: budgetList[index],
              );
            },
            padding: const EdgeInsets.only(bottom: 80),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Budget',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const BudgetForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
