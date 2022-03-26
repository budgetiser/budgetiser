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
              children: const <Widget>[
                Positioned(
                  bottom: 12.0,
                  left: 16.0,
                  child: Text("Budgetiser",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      )),
                )
              ],
            )),
        singleDrawerItem(context, Icons.home, 'Home', 'home'),
        singleDrawerItem(context, Icons.attach_money, 'Budgets', 'budgets'),
        singleDrawerItem(context, Icons.account_balance, 'Account', 'account'),
        Divider(height: 2, thickness: 2, color: Theme.of(context).dividerColor),
        singleDrawerItem(context, Icons.category, 'Categories', 'categories'),
        singleDrawerItem(context, Icons.group_work, 'Groups', 'groups'),
        Divider(height: 2, thickness: 2, color: Theme.of(context).dividerColor),
        singleDrawerItem(context, Icons.show_chart, 'Stats', 'stats'),
        singleDrawerItem(
            context, Icons.payment, 'Transactions', 'transactions'),
        Divider(height: 2, thickness: 2, color: Theme.of(context).dividerColor),
        singleDrawerItem(context, Icons.question_mark, 'Help', 'help'),
        singleDrawerItem(context, Icons.settings, 'Settings', 'settings'),
      ],
    ),
  );
}

Widget singleDrawerItem(
    BuildContext context, IconData icon, String title, String destination) {
  return ListTile(
    title: Text(title),
    leading: Icon(icon),
    onTap: () {
      Navigator.pushReplacementNamed(
          context, destination); //TODO: need to change destination
    },
  );
}
