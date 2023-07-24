import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/settings/about.dart';
import 'package:budgetiser/screens/settings/danger_zone.dart';
import 'package:budgetiser/shared/services/setting_currency.dart';
import 'package:budgetiser/shared/services/settings_stream.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// enum currencySymbol { dollar, pound, euro, yen, rupee, bitcoin, ethereum } //TODO:

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
  String _selectedCurrency = '€';

  @override
  void initState() {
    asyncSetStateFromPreferences();
    super.initState();
  }

  void asyncSetStateFromPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    final awaitedCurrency = await SettingsCurrencyHandler().getCurrency();
    setState(() {
      _selectedDarkModeValue =
          preferences.getString('key-themeMode') ?? 'system';
      _selectedCurrency = awaitedCurrency;
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
          'Settings',
        ),
      ),
      drawer: const CreateDrawer(),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
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
                        Column(
                          children: [
                            for (var item in ['system', 'light', 'dark'])
                              RadioListTile<String>(
                                title: Text(item),
                                value: item,
                                groupValue: _selectedDarkModeValue,
                                onChanged: setAppearance,
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text('Change Currency: $_selectedCurrency'),
              subtitle: const Text(
                'No effect on values',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Select Currency'),
                        ],
                      ),
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          child: Text(
                            'Has no effect on values',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        currencyRadioItem(context, currencySymbol: '€'),
                        currencyRadioItem(context, currencySymbol: '\$'),
                        currencyRadioItem(context, currencySymbol: '£'),
                      ],
                    );
                  },
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
        ),
      ),
    );
  }

  ListTile currencyRadioItem(
    BuildContext context, {
    required String currencySymbol,
  }) {
    return ListTile(
      title: Text(currencySymbol),
      visualDensity: VisualDensity.compact,
      leading: Radio(
        value: currencySymbol,
        groupValue: _selectedCurrency,
        onChanged: (value) {
          setState(() {
            _selectedCurrency = value.toString();
          });
          SettingsCurrencyHandler().setCurrency(value.toString());
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
