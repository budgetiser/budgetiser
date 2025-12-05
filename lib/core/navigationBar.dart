import 'package:budgetiser/accounts/screens/account_form.dart';
import 'package:budgetiser/accounts/screens/account_screen.dart';
import 'package:budgetiser/home/screens/home_screen.dart';
import 'package:budgetiser/settings/screens/settings_screen.dart';
import 'package:budgetiser/statistics/screens/stats_overview.dart';
import 'package:budgetiser/transactions/screens/transaction_form.dart';
import 'package:budgetiser/transactions/screens/transactions_screen.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    AccountScreen(),
    TransactionsScreen(),
    StatsOverview(),
    SettingsScreen(),
  ];

  List<List<Widget>> actions = [
    [IconButton(icon: Icon(Icons.search), onPressed: () {})],
    [
      IconButton(icon: Icon(Icons.add), onPressed: () {}),
      IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
    ],
    [IconButton(icon: Icon(Icons.info_outline), onPressed: () {})],
    [IconButton(icon: Icon(Icons.refresh), onPressed: () {})],
    [IconButton(icon: Icon(Icons.help_outline), onPressed: () {})],
  ];

  // Different FABs depending on the screen:
  Widget? _buildFab() {
    switch (_selectedIndex) {
      case 1: // Account
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AccountForm(),
              ),
            );
          },
          heroTag: 'create-account',
          child: const Icon(Icons.add),
        );
      case 2: // transactions
        return FloatingActionButton(
          child: const Icon(
            Icons.add,
            semanticLabel: 'add transaction',
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const TransactionForm(),
              ),
            );
          },
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          [
            'Home',
            'Account',
            'Transactions',
            'Stats',
            'Settings',
          ][_selectedIndex],
        ),
        actions: actions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      floatingActionButton: _buildFab(),
    );
  }
}
