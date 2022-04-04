import 'package:flutter/material.dart';

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
                  child: Text(
                    "Budgetiser",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                )
              ],
            )),
        singleDrawerItem(context, Icons.home, 'Home', 'home'),
        singleDrawerItem(context, Icons.attach_money, 'Budgets', 'savings'),
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
      ],
    ),
  );
}

Widget singleDrawerItem(
    BuildContext context, IconData icon, String title, String destination) {
  return ListTile(
    title: Text(
      title,
      style: Theme.of(context).textTheme.subtitle1,
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
