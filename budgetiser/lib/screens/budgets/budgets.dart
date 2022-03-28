import 'package:budgetiser/screens/budgets/budgetItem.dart';
import 'package:budgetiser/screens/budgets/newBudget.dart';
import 'package:flutter/material.dart';
import '../../shared/widgets/drawer.dart';

class Budgets extends StatelessWidget {
  static String routeID = 'budgets';

  const Budgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Budgets",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              BudgetItem(
                name: "Restaurantes",
                currentValue: 50,
                endValue: 50,
                color: Colors.red,
              ),
              BudgetItem(
                name: "Party",
                currentValue: 20,
                endValue: 80,
                color: Colors.green,
              ),
              BudgetItem(
                name: "Videospiele",
                currentValue: 22.25,
                endValue: 30,
                color: Colors.purple,
              ),
              BudgetItem(
                name: "Freizeit",
                currentValue: 75,
                endValue: 150,
                color: Colors.blue,
              ),
              BudgetItem(
                name: "Bücher",
                currentValue: 0,
                endValue: 45,
                color: Colors.yellow,
              ),
              BudgetItem(
                name: "Schallplatten",
                currentValue: 1,
                endValue: 85,
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "New Budget",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NewBudget())
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
