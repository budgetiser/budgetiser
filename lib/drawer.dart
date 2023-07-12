import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/logo_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateDrawer extends StatelessWidget {
  const CreateDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
                      const Icon(
                        LogoIcon.budgetiserIcon,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        " Budgetiser",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          singleDrawerItem(context, Icons.home, 'Home', 'home'),
          singleDrawerItem(context, Icons.attach_money, 'Plans', 'plans'),
          singleDrawerItem(
              context, Icons.account_balance, 'Account', 'account'),
          const Divider(thickness: 2, height: 2),
          singleDrawerItem(context, Icons.category, 'Categories', 'categories'),
          singleDrawerItem(context, Icons.group_work, 'Groups', 'groups'),
          const Divider(thickness: 2, height: 2),
          singleDrawerItem(context, Icons.show_chart, 'Stats', 'stats'),
          singleDrawerItem(
              context, Icons.payment, 'Transactions', 'transactions'),
          const Divider(thickness: 2, height: 2),
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
    ModalRoute? route = ModalRoute.of(context);
    String routeName = '';
    if (route != null) {
      if (route.settings.name != null) {
        routeName = route.settings.name!;
      } else {
        routeName = 'transactions';
      }
      // when pressing back in transactions  after getting pushed from home->new_transaction (and getting to home screen) routeName is "/" when reentering app
      if (routeName == "/") {
        routeName = 'home';
      }
    }
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      selected: destination == routeName,
      selectedTileColor: Theme.of(context).splashColor,
      leading: Icon(icon),
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          destination,
        );
      },
    );
  }
}
