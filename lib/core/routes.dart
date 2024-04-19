import 'package:budgetiser/accounts/screens/account_screen.dart';
import 'package:budgetiser/budgets/screens/budgets_screen.dart';
import 'package:budgetiser/categories/screens/categories_screen.dart';
import 'package:budgetiser/help/screens/help.dart';
import 'package:budgetiser/home/screens/home_screen.dart';
import 'package:budgetiser/notes/screens/notes_screen.dart';
import 'package:budgetiser/settings/screens/settings_screen.dart';
import 'package:budgetiser/statistics/screens/stats.dart';
import 'package:budgetiser/statistics/screens/stats_overview.dart';
import 'package:budgetiser/transactions/screens/transactions_screen.dart';

//named lower case and also needs to be defined in beginning of class as: static String routeID = ''
var routes = {
  'home': (context) => const HomeScreen(),
  'budgets': (context) => const BudgetScreen(),
  'account': (context) => const AccountScreen(),
  'categories': (context) => const CategoriesScreen(),
  'stats_overview': (context) => const StatsOverview(),
  'transactions': (context) => const TransactionsScreen(),
  'help': (context) => const HelpScreen(),
  'settings': (context) => const SettingsScreen(),
  'notes123': (context) => NotesScreen(),
};
