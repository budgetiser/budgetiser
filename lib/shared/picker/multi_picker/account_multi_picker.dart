import 'package:budgetiser/db/account_provider.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/picker/multi_picker/general_multi_picker.dart';
import 'package:flutter/material.dart';

class AccountMultiPicker extends StatefulWidget {
  const AccountMultiPicker({
    super.key,
    required this.onAccountsPickedCallback,
    this.initialValues,
  });

  final Function(List<Account> selected) onAccountsPickedCallback;
  final List<Account>? initialValues;

  @override
  State<AccountMultiPicker> createState() => _AccountMultiPickerState();
}

class _AccountMultiPickerState extends State<AccountMultiPicker> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Account>>(
      future: AccountModel().getAllAccounts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Text('Oops!');
        }

        return GeneralMultiPicker<Account>(
          heading: 'Select Accounts',
          onPickedCallback: widget.onAccountsPickedCallback,
          possibleValues: snapshot.data!,
          initialValues: widget.initialValues,
        );
      },
    );
  }
}
