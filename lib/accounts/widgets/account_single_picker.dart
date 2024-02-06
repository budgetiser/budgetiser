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
  });

  final Function(Account selected) onAccountPickedCallback;
  final List<Account>? blacklistedValues;

  @override
  State<AccountSinglePicker> createState() => _AccountSinglePickerState();
}

class _AccountSinglePickerState extends State<AccountSinglePicker> {
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

        return GeneralSinglePicker<Account>(
          onPickedCallback: widget.onAccountPickedCallback,
          possibleValues: snapshot.data!,
          blacklistedValues: widget.blacklistedValues,
        );
      },
    );
  }
}
