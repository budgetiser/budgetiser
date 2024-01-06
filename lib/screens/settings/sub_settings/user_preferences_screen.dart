import 'package:budgetiser/screens/settings/sub_settings/user_preferences/select_currency_list_tile.dart';
import 'package:budgetiser/screens/settings/sub_settings/user_preferences/toggle_prefix_button.dart';
import 'package:flutter/material.dart';

class UserPreferencesScreen extends StatelessWidget {
  const UserPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Preferences',
        ),
      ),
      body: Center(
        child: ListView(
          children: const [
            SelectCurrencyListTile(),
            TogglePrefixButtonListTile(),
          ],
        ),
      ),
    );
  }
}
