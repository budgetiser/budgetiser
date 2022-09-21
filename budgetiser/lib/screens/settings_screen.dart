import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/shared/services/settingsStream.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
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
  String? _selectedDarkModeValue;

  @override
  void initState() {
    asyncSetStateFromPreferences();
    super.initState();
  }

  void asyncSetStateFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDarkModeValue = prefs.getString('key-themeMode');
      _selectedDarkModeValue ??= 'system'; // default value
    });
  }

  void setAppearance(String? value) {
    setState(() {
      _selectedDarkModeValue = value;
    });
    if (value != null) {
      SettingsStreamClass.instance.setThemeModeFromString(value);
    }
    Navigator.of(context).pop();
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
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Appearance'),
              subtitle: const Text('Choose your light or dark theme',
                  style: TextStyle(fontSize: 14.0)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      elevation: 0,
                      title: const Text('Appearance'),
                      children: [
                        Column(children: <Widget>[
                          RadioListTile<String>(
                            title: const Text('system'),
                            value: "system",
                            groupValue: _selectedDarkModeValue,
                            onChanged: setAppearance,
                          ),
                          RadioListTile<String>(
                            title: const Text('light'),
                            value: "light",
                            groupValue: _selectedDarkModeValue,
                            onChanged: setAppearance,
                          ),
                          RadioListTile<String>(
                            title: const Text('dark'),
                            value: "dark",
                            groupValue: _selectedDarkModeValue,
                            onChanged: setAppearance,
                          ),
                        ]),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Export Database'),
              subtitle: const Text('Into Downloads',
                  style: TextStyle(fontSize: 14.0)),
              onTap: () async {
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
            ),
            ListTile(
              title: const Text('Import Database'),
              subtitle: const Text('From Downloads',
                  style: TextStyle(fontSize: 14.0)),
              onTap: () async {
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
            ),
          ],
        ),
      ),
    );
  }
}
