import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/shared/services/settingsStream.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  static String routeID = 'settings';
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? selectedValue;

  @override
  void initState() {
    asyncSetStateFromPreferences();
    super.initState();
  }

  void asyncSetStateFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedValue = prefs.getString('key-themeMode');
      selectedValue ??= 'system'; // default value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),
      drawer: createDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Settings Page',
            ),
            DropdownButton<String>(
                value: selectedValue,
                items: const [
                  DropdownMenuItem(
                    value: "system",
                    child: Text("system"),
                  ),
                  DropdownMenuItem(
                    value: "light",
                    child: Text("light"),
                  ),
                  DropdownMenuItem(
                    value: "dark",
                    child: Text("dark"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                    if (value != null) {
                      SettingsStreamClass.instance
                          .setThemeModeFromString(value);
                    }
                  });
                }),
            ElevatedButton(
              onPressed: (() => DatabaseHelper.instance.exportDB()),
              child: Text("export db to downloads"),
            ),
          ],
        ),
      ),
    );
  }
}
