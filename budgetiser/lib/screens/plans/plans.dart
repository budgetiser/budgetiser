import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/plans/budget_form.dart';
import 'package:budgetiser/screens/plans/saving_form.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/widgets/items/budget_item.dart';
import 'package:budgetiser/shared/widgets/items/saving_item.dart';
import 'package:flutter/material.dart';

class Plans extends StatefulWidget {
  static String routeID = 'plans';

  const Plans({Key? key}) : super(key: key);

  @override
  State<Plans> createState() => _PlansState();
}

enum Pages { budgets, savings }

class _PlansState extends State<Plans> {
  final PageController _pageController = PageController(
    initialPage: Pages.budgets.index,
  );
  String title = "Budgets";
  String buttonTooltip = "Create Budget";
  int _currentPage = Pages.budgets.index;

  @override
  void initState() {
    DatabaseHelper.instance.pushGetAllBudgetsStream();
    DatabaseHelper.instance.pushGetAllSavingsStream();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: createDrawer(context),
      body: PageView(
        onPageChanged: (int page) {
          setState(() {
            if (page == Pages.budgets.index) {
              title = "Budgets";
              buttonTooltip = "Create Budget";
              _currentPage = Pages.budgets.index;
              DatabaseHelper.instance.pushGetAllBudgetsStream();
            } else if (page == Pages.savings.index) {
              title = "Savings";
              buttonTooltip = "Create Saving";
              _currentPage = Pages.savings.index;
              DatabaseHelper.instance.pushGetAllSavingsStream();
            }
          });
        },
        children: [
          StreamBuilder<List<Budget>>(
            stream: DatabaseHelper.instance.allBudgetsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Budget> budgetList = snapshot.data!.toList();
                budgetList.sort((a, b) => a.compareTo(b));
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
              } else if (snapshot.hasError) {
                return const Text("Oops!");
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          StreamBuilder<List<Savings>>(
            stream: DatabaseHelper.instance.allSavingsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Savings> savingsList = snapshot.data!.toList();
                savingsList.sort((a, b) => a.name.compareTo(b.name));
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: savingsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SavingItem(
                      savingData: savingsList[index],
                    );
                  },
                  padding: const EdgeInsets.only(bottom: 80),
                );
              } else if (snapshot.hasError) {
                return const Text("Oops!");
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: _currentPage == Pages.budgets.index
          ? FloatingActionButton(
              tooltip: buttonTooltip,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BudgetForm()));
              },
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              tooltip: buttonTooltip,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SavingForm()));
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
