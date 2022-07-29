import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/shared/services/settingsStream.dart';
import 'package:budgetiser/shared/widgets/confirmationDialog.dart';
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
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: "Attention",
                      description:
                          "Are you sure? This will potentially override existing budgetiser.db file in the Download folder!",
                      onSubmitCallback: () {
                        DatabaseHelper.instance.exportDB();
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              child: Text("export db to downloads"),
            ),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: "Attention",
                      description:
                          "Are you sure? This will override current state of the app! This cannot be undone! A correct DB file (budgetiser.db) must be present in the Downloads folder!",
                      onSubmitCallback: () {
                        DatabaseHelper.instance.importDB();
                        Navigator.of(context).pop();
                      },
                      onCancelCallback: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              child: Text("import db from downloads"),
            ),
          ],
        ),
      ),
    );
  }
}
