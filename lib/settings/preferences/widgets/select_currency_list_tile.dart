import 'package:budgetiser/settings/services/setting_currency.dart';
import 'package:flutter/material.dart';

class SelectCurrencyListTile extends StatefulWidget {
  const SelectCurrencyListTile({super.key});

  @override
  State<SelectCurrencyListTile> createState() => _SelectCurrencyListTileState();
}

class _SelectCurrencyListTileState extends State<SelectCurrencyListTile> {
  String _selectedCurrency = '€';
  final _currencyFormKey = GlobalKey<FormState>();
  final inputControllerCurrency = TextEditingController(text: '');

  @override
  void initState() {
    asyncSetStateFromPreferences();
    super.initState();
  }

  @override
  void dispose() {
    inputControllerCurrency.dispose();
    super.dispose();
  }

  void asyncSetStateFromPreferences() async {
    final awaitedCurrency = await SettingsCurrencyHandler().getCurrency();
    setState(() {
      _selectedCurrency = awaitedCurrency;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    inputControllerCurrency.text.toString();
                              });
                              SettingsCurrencyHandler().setCurrency(
                                inputControllerCurrency.text.toString(),
                              );
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
                ),
              ],
            );
          },
        );
      },
    );
  }
}
