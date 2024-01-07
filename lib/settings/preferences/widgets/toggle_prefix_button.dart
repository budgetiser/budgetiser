import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// changes setting if the prefix button in the transaction-form is visible
class TogglePrefixButtonListTile extends StatefulWidget {
  const TogglePrefixButtonListTile({super.key});

  @override
  State<TogglePrefixButtonListTile> createState() =>
      _TogglePrefixButtonListTileState();
}

class _TogglePrefixButtonListTileState
    extends State<TogglePrefixButtonListTile> {
  bool _currentState = true; // default value for this setting

  @override
  void initState() {
    asyncSetStateFromPreferences();
    super.initState();
  }

  void asyncSetStateFromPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _currentState =
          preferences.getBool('key-prefix-button-active') ?? _currentState;
    });
  }

  void onChanged(bool value) async {
    setState(() {
      _currentState = value;
    });
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool('key-prefix-button-active', value);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Prefix button'),
      subtitle:
          const Text('Activate the prefix button in the transaction form'),
      value: _currentState,
      onChanged: (bool? value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
