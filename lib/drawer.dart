import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/logo_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget createDrawer(BuildContext context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 12.0,
                left: 16.0,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(
                        LogoIcon.budgetiserIcon,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // TODO: Bug: Text clips with big system font size
                    Text('Budgetiser',
                        style: Theme.of(context).textTheme.displayLarge),
                  ],
                ),
              )
            ],
          ),
        ),
        singleDrawerItem(context, Icons.home, 'Home', 'home'),
        singleDrawerItem(context, Icons.attach_money, 'Plans', 'plans'),
        singleDrawerItem(context, Icons.account_balance, 'Account', 'account'),
        const Divider(thickness: 2),
        singleDrawerItem(context, Icons.category, 'Categories', 'categories'),
        singleDrawerItem(context, Icons.group_work, 'Groups', 'groups'),
        const Divider(thickness: 2),
        singleDrawerItem(context, Icons.show_chart, 'Stats', 'stats'),
        singleDrawerItem(
            context, Icons.payment, 'Transactions', 'transactions'),
        const Divider(thickness: 2),
        singleDrawerItem(context, Icons.question_mark, 'Help', 'help'),
        singleDrawerItem(context, Icons.settings, 'Settings', 'settings'),
        singleDrawerItem(context, Icons.list_alt, 'Notes', 'notes123'),
        // ListTile for the logout button
        ListTile(
          title: Text(
            'Exit',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.redAccent,
                ),
          ),
          leading: const Icon(
            Icons.logout,
            color: Colors.redAccent,
          ),
          onTap: () {
            DatabaseHelper.instance.logout();
            SystemNavigator.pop();
          },
        ),
      ],
    ),
  );
}

Widget singleDrawerItem(
    BuildContext context, IconData icon, String title, String destination) {
  return ListTile(
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    ),
    leading: Icon(icon),
    onTap: () {
      Navigator.pushReplacementNamed(
        context,
        destination,
      );
    },
  );
}
