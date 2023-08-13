import 'dart:async';

import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/picker/multi_picker/general_multi_picker.dart';
import 'package:flutter/material.dart';

class AccountPicker extends StatefulWidget {
  const AccountPicker({
    Key? key,
    required this.onAccountPickedCallback,
  }) : super(key: key);

  final Function(List<Account>) onAccountPickedCallback;

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
          _allAccounts = value;
        });
      },
    );
    DatabaseHelper.instance.pushGetAllAccountsStream();

    super.initState();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GeneralMultiPicker<Account>(
      heading: 'Select Accounts',
      callback: widget.onAccountPickedCallback,
      allValues: _allAccounts,
    );
  }
}
