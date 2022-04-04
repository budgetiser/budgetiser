import 'package:budgetiser/screens/budgets/budgets.dart';
import 'package:budgetiser/screens/budgets/newBudget.dart';
import 'package:budgetiser/screens/savings/newSaving.dart';
import 'package:budgetiser/screens/savings/savings.dart';
import 'package:budgetiser/shared/widgets/drawer.dart';
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      drawer: createDrawer(context),
      body: PageView(
        onPageChanged: (int page) {
          setState(() {
            if(page == pages.budgets.index){
              title = "Budgets";
              buttonTooltip = "Create Budget";
              _currentPage = pages.budgets.index;
            }else if(page == pages.savings.index){
              title = "Savings";
              buttonTooltip = "Create Saving";
              _currentPage = pages.savings.index;
            }
          });
        },
        children: [
          Budgets(),
          Savings(),
        ],
      ),
      floatingActionButton: _currentPage == pages.budgets.index ?
      FloatingActionButton(
        tooltip: buttonTooltip,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewBudget()));
        },
        child: const Icon(Icons.add),
      ):
      FloatingActionButton(
        tooltip: buttonTooltip,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NewSaving()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
