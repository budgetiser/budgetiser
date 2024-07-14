import 'package:budgetiser/accounts/screens/account_form.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/shared/widgets/picker/selectable/single_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSinglePicker extends StatefulWidget {
  const AccountSinglePicker({
    super.key,
    required this.onAccountPickedCallback,
    this.blacklistedValues,
    this.ignoreArchived = false,
  });

  final Function(Account selected) onAccountPickedCallback;
  final List<Account>? blacklistedValues;
  final bool ignoreArchived;

  @override
  State<AccountSinglePicker> createState() => _AccountSinglePickerState();
}

class _AccountSinglePickerState extends State<AccountSinglePicker> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Account>>(
      future: Provider.of<AccountModel>(context, listen: false).getAllAccounts(
        ignoreArchived: widget.ignoreArchived,
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

        return GeneralSinglePicker<Account>(
          onPickedCallback: widget.onAccountPickedCallback,
          possibleValues: snapshot.data!,
          blacklistedValues: widget.blacklistedValues,
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
