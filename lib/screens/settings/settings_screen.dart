import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/settings/about.dart';
import 'package:budgetiser/shared/services/setting_currency.dart';
import 'package:budgetiser/shared/services/settings_stream.dart';
import 'package:budgetiser/shared/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

// enum currencySymbol { dollar, pound, euro, yen, rupee, bitcoin, ethereum }

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
                          children: <Widget>[
                            RadioListTile<String>(
                              title: const Text('system'),
                              value: 'system',
                              groupValue: _selectedDarkModeValue,
                              onChanged: setAppearance,
                            ),
                            RadioListTile<String>(
                              title: const Text('light'),
                              value: 'light',
                              groupValue: _selectedDarkModeValue,
                              onChanged: setAppearance,
                            ),
                            RadioListTile<String>(
                              title: const Text('dark'),
                              value: 'dark',
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
              title: const Text('Export Database'),
              subtitle: const Text(
                'Into android/data',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'Are you sure? This will potentially override existing budgetiser.db file in the Download folder!',
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
              title: const Text('Export Database (JSON)'),
              subtitle: const Text(
                'Into android/data',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'Are you sure? This will potentially override existing budgetiser.json file in the App folder!',
                      onSubmitCallback: () {
                        DatabaseHelper.instance.exportAsJson();
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
              subtitle: const Text(
                'From android/data',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'Are you sure? This will override current state of the app! This cannot be undone! A correct DB file (budgetiser.db) must be present in Android/data/de.budgetiser.budgetiser/files/downloads folder!',
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
              title: const Text('Reset DB'),
              subtitle: const Text(
                'Clear all entries',
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Attention',
                      description:
                          'This action cannot be undone! All data will be lost.',
                      onSubmitCallback: () async {
                        await DatabaseHelper.instance.resetDB();
                        // ignore: use_build_context_synchronously
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
                title: const Text('Reset and fill DB'),
                subtitle: const Text(
                  'Clear all entries and fill with demo data',
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        title: 'Attention',
                        description:
                            'This action cannot be undone! All current data will be lost.',
                        onSubmitCallback: () async {
                          await DatabaseHelper.instance.resetDB();
                          DatabaseHelper.instance.fillDBwithTMPdata();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        },
                        onCancelCallback: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }),
            ListTile(
              title: const Text('About'),
              subtitle: const Text(
                'Version, Source code, ...',
              ),
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AboutScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile currencyRadioItem(BuildContext context,
      {required String currencySymbol}) {
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
