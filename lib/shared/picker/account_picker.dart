import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/picker/multi_account_picker/picker_content.dart';
import 'package:flutter/material.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';

class AccountPicker extends StatefulWidget {
  const AccountPicker({
    Key? key,
    required this.onAccountPickedCallback,
  }) : super(key: key);

  @override
  State<AccountPicker> createState() => _AccountPickerState();
  final Function(List<Account>) onAccountPickedCallback;
}

class _AccountPickerState extends State<AccountPicker> {
  var scrollController = ScrollController();

  @override
  void initState() {
    DatabaseHelper.instance.pushGetAllAccountsStream();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Account>>(
      stream: DatabaseHelper.instance.allAccountsStream,
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return PickerContent<Account>(
            allValues: snapshot.data!,
            heading: "Select Account",
            callback: widget.onAccountPickedCallback,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
