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
  late List<Account> _allAccounts = [];

  @override
  void initState() {
    // TODO: Broken: setting _allAccounts only after 2nd build
    AccountModel().getAllAccounts().then((value) => _allAccounts = value);
    super.initState();
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
