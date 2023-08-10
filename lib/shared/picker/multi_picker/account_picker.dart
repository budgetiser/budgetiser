import 'dart:async';

import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/picker/multi_picker/picker_content.dart';
import 'package:flutter/material.dart';

class AccountPicker extends StatefulWidget {
  const AccountPicker({
    Key? key,
    required this.onAccountPickedCallback,
    // required this.initialSelected,
  }) : super(key: key);

  final Function(List<Account>) onAccountPickedCallback;
  // final List<Account> initialSelected;

  @override
  State<AccountPicker> createState() => _AccountPickerState();
}

class _AccountPickerState extends State<AccountPicker> {
  List<Account> _allAccounts = [];
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    streamSubscription = DatabaseHelper.instance.allAccountsStream.listen(
      (value) {
        setState(() {
          _allAccounts = value.cast();
        });
      },
    );
    DatabaseHelper.instance.pushGetAllAccountsStream();
    super.initState();
    streamSubscription;
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GeneralMultiPicker<Account>(
      heading: 'Select Account',
      callback: widget.onAccountPickedCallback,
      allValues: _allAccounts,
    );
  }
}
