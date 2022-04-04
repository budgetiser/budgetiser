import 'package:budgetiser/screens/budgets.dart';
import 'package:budgetiser/screens/categories/categories.dart';
import 'package:budgetiser/screens/groups.dart';
import 'package:budgetiser/screens/help.dart';
import 'package:budgetiser/screens/savings/savings.dart';
import 'package:budgetiser/screens/settings.dart';
import 'package:budgetiser/screens/stats.dart';
import 'package:budgetiser/screens/transactions/transactions.dart';

import 'screens/account/accountScreen.dart';
import 'screens/home.dart';

//named lower case and also needs to be defined in beginning of class as: static String routeID = ''
var routes = {
  'home': (context) => Home(),
  'budgets': (context) => Budgets(),
  'savings': (context) => Savings(),
  'account': (context) => AccountScreen(),
  'categories': (context) => Categories(),
  'groups': (context) => Groups(),
  'stats': (context) => Stats(),
  'transactions': (context) => Transactions(),
  'help': (context) => Help(),
  'settings': (context) => Settings(),
};
