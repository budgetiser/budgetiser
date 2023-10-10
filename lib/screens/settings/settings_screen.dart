import 'package:budgetiser/drawer.dart';
import 'package:budgetiser/screens/settings/about.dart';
import 'package:budgetiser/screens/settings/danger_zone.dart';
import 'package:budgetiser/shared/services/setting_currency.dart';
import 'package:budgetiser/shared/services/settings_stream.dart';
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
  String _selectedCurrency = '€';
  final _currencyFormKey = GlobalKey<FormState>();
  final inputControllerCurrency = TextEditingController(text: '');

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
                      title: const Text('Select Currency'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Has no effect on values',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                key: _currencyFormKey,
                                controller: inputControllerCurrency,
                                maxLength: 5,
                                onFieldSubmitted: (value) {
                                  setState(() {
                                    _selectedCurrency = value.toString();
                                  });
                                  SettingsCurrencyHandler()
                                      .setCurrency(value.toString());
                                  Navigator.of(context).pop();
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FloatingActionButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    backgroundColor: Colors.red,
                                    mini: true,
                                    child: const Icon(Icons.close),
                                  ),
                                  FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedCurrency =
                                            inputControllerCurrency.text
                                                .toString();
                                      });
                                      SettingsCurrencyHandler().setCurrency(
                                          inputControllerCurrency.text
                                              .toString());
                                      Navigator.pop(context);
                                    },
                                    backgroundColor: Colors.green,
                                    mini: true,
                                    child: const Icon(Icons.check),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
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
}
