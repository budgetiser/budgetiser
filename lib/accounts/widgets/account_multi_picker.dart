import 'package:budgetiser/accounts/screens/account_form.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/shared/widgets/picker/selectable/multi_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      future:
          Provider.of<AccountModel>(context, listen: false).getAllAccounts(),
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
          noDataButton: snapshot.data!.isEmpty
              ? TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // pop dialog, so that after creation the not reloaded dialog is not visible (todo: reload dialog directly)
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AccountForm(),
                      ),
                    );
                  },
                  child: const Text(
                    'Create an Account',
                  ),
                )
              : null,
        );
      },
    );
  }
}
