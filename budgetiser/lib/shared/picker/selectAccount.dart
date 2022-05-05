import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:flutter/material.dart';

class SelectAccount extends StatefulWidget {
  SelectAccount({
    Key? key,
    this.initialAccount,
    required this.callback,
    // this.blackListAccountId,
  }) : super(key: key);
  Account? initialAccount;
  final Function(Account) callback;
  // int? blackListAccountId = 1;

  @override
  _SelectAccountState createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  List<Account>? _accounts;
  Account? selectedAccount;

  @override
  void initState() {
    DatabaseHelper.instance.allAccountsStream.listen((event) {
      setState(() {
        _accounts?.clear();
        _accounts = (event.map((e) => e).toList());
        // .where((element) => element.id != widget.blackListAccountId)
        // .toList();
        if (widget.initialAccount != null) {
          selectedAccount = _accounts?.firstWhere(
              (element) => element.id == widget.initialAccount!.id);
        } else {
          selectedAccount = _accounts?.first;
        }
      });
      widget.callback(selectedAccount!);
    });
    DatabaseHelper.instance.pushGetAllAccountsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   if (_accounts != null) {
    //     List<Account> TMPaccounts = _accounts!;
    //     // _accounts?.clear();
    //     _accounts = TMPaccounts.where(
    //         (element) => element.id != widget.blackListAccountId).toList();
    //   }
    // });
    // print(
    //     "_accounts: ${_accounts?.length}; selectedAccount: ${selectedAccount?.id}");
    return Row(
      children: [
        const Text("Account:"),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton<Account>(
            isExpanded: true,
            value: selectedAccount,
            elevation: 16,
            onChanged: (Account? newValue) {
              setState(() {
                widget.callback(newValue!);
                selectedAccount = newValue;
              });
            },
            items: _accounts?.map<DropdownMenuItem<Account>>((Account account) {
              return DropdownMenuItem<Account>(
                value: account,
                child: Text(
                  account.name,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
