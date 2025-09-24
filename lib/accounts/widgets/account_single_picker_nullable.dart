import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/shared/widgets/picker/selectable/single_picker_nullable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSinglePickerNullable extends StatefulWidget {
  const AccountSinglePickerNullable({
    super.key,
    required this.onAccountPickedCallback,
    this.blacklistedValues,
    this.ignoreArchived = false,
  });

  final Function(Account? selected) onAccountPickedCallback;
  final List<Account>? blacklistedValues;
  final bool ignoreArchived;

  @override
  State<AccountSinglePickerNullable> createState() =>
      _AccountSinglePickerNullableState();
}

class _AccountSinglePickerNullableState
    extends State<AccountSinglePickerNullable> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Account>>(
      future: Provider.of<AccountModel>(context, listen: false).getAllAccounts(
        excludeArchived: widget.ignoreArchived,
      ),
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
          title: 'Select an account',
          onPickedCallback: widget.onAccountPickedCallback,
          possibleValues: snapshot.data!,
          blacklistedValues: widget.blacklistedValues,
        );
      },
    );
  }
}
