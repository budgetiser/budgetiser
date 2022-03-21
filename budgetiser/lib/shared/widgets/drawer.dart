import 'package:budgetiser/main.dart';
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
        singleDrawerItem(context, Icons.home, 'Home', 'Home'),
        singleDrawerItem(context, Icons.attach_money, 'Budgets', 'Budgets'),
        singleDrawerItem(context, Icons.account_balance, 'Account', 'Account'),
        singleDrawerItem(context, Icons.category, 'Categories', 'Categories'),
        singleDrawerItem(context, Icons.group_work, 'Groups', 'Groups'),
        singleDrawerItem(context, Icons.show_chart, 'Stats', 'Stats'),
        singleDrawerItem(
            context, Icons.payment, 'Transactions', 'Transactions'),
        singleDrawerItem(context, Icons.question_mark, 'Help', 'Help'),
        singleDrawerItem(context, Icons.settings, 'Settings', 'Settings'),
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
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                  title: destination))); //TODO: need to change destination
    },
  );
}
