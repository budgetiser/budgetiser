import 'package:budgetiser/screens/categories/categories.dart';
import 'package:budgetiser/screens/groups.dart';
import 'package:budgetiser/screens/help.dart';
import 'package:budgetiser/screens/plans.dart';
import 'package:budgetiser/screens/settings.dart';
import 'package:budgetiser/screens/stats.dart';
import 'package:budgetiser/screens/transactions/transactionsScreen.dart';

import 'screens/account/accountScreen.dart';
import 'screens/homeScreen.dart';

//named lower case and also needs to be defined in beginning of class as: static String routeID = ''
var routes = {
  'home': (context) => Home(),
  'plans': (context) => Plans(),
  'account': (context) => AccountScreen(),
  'categories': (context) => Categories(),
  'groups': (context) => Groups(),
  'stats': (context) => Stats(),
  'transactions': (context) => TransactionsScreen(),
  'help': (context) => Help(),
  'settings': (context) => Settings(),
};
