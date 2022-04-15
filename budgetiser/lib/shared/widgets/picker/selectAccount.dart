import 'package:budgetiser/bd/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
import 'package:flutter/material.dart';

class SelectAccount extends StatefulWidget {
  SelectAccount({
    Key? key,
    this.initialAccount,
    required this.callback,
  }) : super(key: key);
  Account? initialAccount;
  final Function(Account) callback;

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
        if (widget.initialAccount != null) {
          selectedAccount = _accounts?.firstWhere(
              (element) => element.id == widget.initialAccount!.id);
        } else {
          selectedAccount = _accounts?.first;
        }
      });
    });
    DatabaseHelper.instance.pushGetAllAccountsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Account:"),
        const SizedBox(width: 8),
        DropdownButton<Account>(
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
              child: Text(account.name),
            );
          }).toList(),
        ),
      ],
    );
  }
}
