import 'package:budgetiser/screens/categories/categoriesScreen.dart';
import 'package:budgetiser/screens/groups/groupsScreen.dart';
import 'package:budgetiser/screens/help.dart';
import 'package:budgetiser/screens/plans/plans.dart';
import 'package:budgetiser/screens/settings.dart';
import 'package:budgetiser/screens/stats.dart';
import 'package:budgetiser/screens/transactions/transactionsScreen.dart';

import 'screens/account/accountScreen.dart';
import 'screens/homeScreen.dart';

//named lower case and also needs to be defined in beginning of class as: static String routeID = ''
var routes = {
  'home': (context) => const HomeScreen(),
  'plans': (context) => const Plans(),
  'account': (context) => AccountScreen(),
  'categories': (context) => const CategoriesScreen(),
  'groups': (context) => const GroupsScreen(),
  'stats': (context) => const Stats(),
  'transactions': (context) => const TransactionsScreen(),
  'help': (context) => const Help(),
  'settings': (context) => const Settings(),
};
