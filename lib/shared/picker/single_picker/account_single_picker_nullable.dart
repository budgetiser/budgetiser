import 'package:budgetiser/db/account_provider.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/picker/single_picker/general_single_picker_nullable.dart';
import 'package:flutter/material.dart';

class AccountSinglePickerNullable extends StatefulWidget {
  const AccountSinglePickerNullable({
    super.key,
    required this.onAccountPickedCallback,
    this.blacklistedValues,
  });

  final Function(Account? selected) onAccountPickedCallback;
  final List<Account>? blacklistedValues;

  @override
  State<AccountSinglePickerNullable> createState() =>
      _AccountSinglePickerNullableState();
}

class _AccountSinglePickerNullableState
    extends State<AccountSinglePickerNullable> {
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

        return GeneralSinglePickerNullable<Account>(
          onPickedCallback: widget.onAccountPickedCallback,
          possibleValues: snapshot.data!,
          blacklistedValues: widget.blacklistedValues,
        );
      },
    );
  }
}
