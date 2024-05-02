import 'package:budgetiser/core/logo_icon.dart';
import 'package:flutter/material.dart';

class CreateDrawer extends StatefulWidget {
  const CreateDrawer({super.key});

  @override
  State<CreateDrawer> createState() => _CreateDrawerState();
}

/// For some reason the drawer class ignores class constructor arguments to give the index of wich page it was selected (bad practice anyway)
/// using a global to remember the current screen works the most reliable any easiest
/// Documentation does not explain how to set this variable otherwise, when screens are split between different files.
int screenIndex = 0;

class _CreateDrawerState extends State<CreateDrawer> {
  @override
  void initState() {
    super.initState();
  }

  /// list off all routes in same order as in drawer
  List<String> routeNames = [
    'home',
    'budgets',
    'account',
    'categories',
    'transactions',
    'stats_overview',
    'help',
    'settings',
    'notes123',
  ];

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
    // pop drawer and push in a way, that the back button first goes to the home screen and then closes the app
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeNames[selectedScreen],
      ModalRoute.withName('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: handleScreenChanged,
      selectedIndex: screenIndex,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Row(
            children: [
              const Icon(
                LogoIcon.budgetiserIcon,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(width: 8),
              // TODO: Bug: Text clips with big system font size
              Text(
                'Budgetiser',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
        ),
        singleDrawerItem(Icons.home, 'Home'),
        singleDrawerItem(Icons.attach_money, 'Budgets'),
        singleDrawerItem(Icons.account_balance, 'Account'),
        singleDrawerItem(Icons.category, 'Categories'),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Transactions', // TODO better name that describes all screens that in/output data
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        singleDrawerItem(Icons.payment, 'Transactions'),
        singleDrawerItem(Icons.show_chart, 'Stats'),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Other',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        singleDrawerItem(Icons.question_mark, 'Help'),
        singleDrawerItem(Icons.settings, 'Settings'),
        singleDrawerItem(Icons.list_alt, 'Notes'),
      ],
    );
  }

  Widget singleDrawerItem(
    IconData icon,
    String title,
  ) {
    return NavigationDrawerDestination(
      label: Text(title),
      icon: Icon(icon),
    );
  }
}
