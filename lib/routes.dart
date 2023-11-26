import 'package:budgetiser/screens/account/account_screen.dart';
import 'package:budgetiser/screens/budgets/budgets.dart';
import 'package:budgetiser/screens/categories/categories_screen.dart';
import 'package:budgetiser/screens/help.dart';
import 'package:budgetiser/screens/home_screen.dart';
import 'package:budgetiser/screens/notes_screen.dart';
import 'package:budgetiser/screens/settings/settings_screen.dart';
import 'package:budgetiser/screens/stats/stats.dart';
import 'package:budgetiser/screens/transactions/transactions_screen.dart';

//named lower case and also needs to be defined in beginning of class as: static String routeID = ''
var routes = {
  'home': (context) => const HomeScreen(),
  'budgets': (context) => const Budgets(),
  'account': (context) => const AccountScreen(),
  'categories': (context) => const CategoriesScreen(),
  'stats': (context) => const Stats(),
  'transactions': (context) => const TransactionsScreen(),
  'help': (context) => const HelpScreen(),
  'settings': (context) => const SettingsScreen(),
  'notes123': (context) => NotesScreen(),
};
