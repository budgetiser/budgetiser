import 'package:budgetiser/settings/services/settings_stream.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppearanceSettingTile extends StatefulWidget {
  const AppearanceSettingTile({super.key});

  @override
  State<AppearanceSettingTile> createState() => _AppearanceSettingTileState();
}

class _AppearanceSettingTileState extends State<AppearanceSettingTile> {
  String? _selectedDarkModeValue;

  @override
  void initState() {
    asyncSetStateFromPreferences();
    super.initState();
  }

  void asyncSetStateFromPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _selectedDarkModeValue =
          preferences.getString('key-themeMode') ?? 'system';
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
    return ListTile(
      title: const Text('Appearance'),
      subtitle: const Text(
        'Choose your light or dark theme',
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Appearance'),
              children: [
                RadioGroup<String>(
                  groupValue: _selectedDarkModeValue,
                  onChanged: setAppearance,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: const Text('System'),
                        leading: Radio<String>(value: 'system'),
                      ),
                      ListTile(
                        title: const Text('Light'),
                        leading: Radio<String>(value: 'light'),
                      ),
                      ListTile(
                        title: const Text('Dark'),
                        leading: Radio<String>(value: 'dark'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
