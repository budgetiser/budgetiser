import 'package:budgetiser/settings/preferences/screens/user_preferences_screen.dart';
import 'package:budgetiser/settings/screens/about.dart';
import 'package:budgetiser/settings/screens/danger_zone.dart';
import 'package:budgetiser/settings/widgets/appearance_setting_tile.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });
  static String routeID = 'settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const AppearanceSettingTile(),
        ListTile(
          title: const Text('User Preferences'),
          subtitle: const Text(
            'Change the app to your own preferences',
          ),
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserPreferencesScreen(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text(
            'Danger Zone',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          subtitle: const Text(
            'Manage stored data (im-/export)',
          ),
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DangerZone(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('About'),
          subtitle: const Text(
            'Version, Source code, Website',
          ),
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AboutScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
