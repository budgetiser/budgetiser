import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/plans/budgetForm.dart';
import 'package:budgetiser/screens/plans/savingForm.dart';
import 'package:budgetiser/shared/dataClasses/budget.dart';
import 'package:budgetiser/shared/dataClasses/savings.dart';
import 'package:budgetiser/shared/widgets/budgetItem.dart';
import 'package:budgetiser/shared/widgets/savingItem.dart';
import 'package:flutter/material.dart';


class Plans extends StatefulWidget {
  static String routeID = 'plans';

  const Plans({Key? key}) : super(key: key);

  @override
  State<Plans> createState() => _PlansState();
}

enum pages { budgets, savings }

class _PlansState extends State<Plans> {
  PageController _pageController = PageController(
    initialPage: pages.budgets.index,
  );
  String title = "Budgets";
  String buttonTooltip = "Create Budget";
  int _currentPage = pages.budgets.index;

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
            if (page == pages.budgets.index) {
              title = "Budgets";
              buttonTooltip = "Create Budget";
              _currentPage = pages.budgets.index;
              DatabaseHelper.instance.pushGetAllBudgetsStream();
            } else if (page == pages.savings.index) {
              title = "Savings";
              buttonTooltip = "Create Saving";
              _currentPage = pages.savings.index;
              DatabaseHelper.instance.pushGetAllSavingsStream();
            }
          });
        },
        children: [
          StreamBuilder<List<Budget>>(
            stream: DatabaseHelper.instance.allBudgetsStream,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                List<Budget> _budgets = snapshot.data!.toList();
                _budgets.sort((a, b) => a.compareTo(b));
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _budgets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BudgetItem(
                      budgetData: _budgets[index],
                    );
                  },
                );
              }else if (snapshot.hasError) {
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
              if(snapshot.hasData){
                List<Savings> _savings = snapshot.data!.toList();
                _savings.sort((a, b) => a.name.compareTo(b.name));
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _savings.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SavingItem(
                      savingData: _savings[index],
                    );
                  },
                );
              }else if (snapshot.hasError) {
                return const Text("Oops!");
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: _currentPage == pages.budgets.index
          ? FloatingActionButton(
              tooltip: buttonTooltip,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BudgetForm()));
              },
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              tooltip: buttonTooltip,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SavingForm()));
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
