import 'package:budgetiser/db/account_provider.dart';
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

  @override
  void initState() {
    super.initState();

    AccountModel().getAllAccounts().then((value) => _allAccounts = value);
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
