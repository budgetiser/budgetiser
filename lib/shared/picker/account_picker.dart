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
  List<Account>? _selectedAccounts;

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
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            DatabaseHelper.instance.pushGetAllAccountsStream();
            return AlertDialog(
              title: const Text('Select Accounts'),
              content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return StreamBuilder<List<Account>>(
                  stream: DatabaseHelper.instance.allAccountsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return PickerContent<Account>(key: widget.key, values: snapshot.data!, initials: _selectedAccounts);
                    } else if (snapshot.hasError) {
                      return const Text("An error occurred!");
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              })
            );
          }).then((value) => {
            if(value != null){
              setState(() {
                _selectedAccounts = value;
                widget.onAccountPickedCallback(value);
              })
            }
        });
      },
      child: const ListTile(
        leading: Icon(Icons.add),
        iconColor: Colors.white,
        title: Center(child:Text("Select Account")),
      ),
    );
  }
}
