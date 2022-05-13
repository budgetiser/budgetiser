import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/account/accountScreen.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/widgets/smallStuff/accountTextWithIcon.dart';
import 'package:flutter/material.dart';

class SelectAccount extends StatefulWidget {
  const SelectAccount({
    Key? key,
    this.initialAccount,
    required this.callback,
    // this.blackListAccountId,
  }) : super(key: key);
  final Account? initialAccount;
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
      _accounts?.clear();
      _accounts = (event.map((e) => e).toList());
      // .where((element) => element.id != widget.blackListAccountId)
      // .toList();
      if (widget.initialAccount != null) {
        selectedAccount = _accounts
            ?.firstWhere((element) => element.id == widget.initialAccount!.id);
      } else {
        selectedAccount = _accounts?.first;
      }
      if (selectedAccount != null) {
        if (mounted) {
          widget.callback(selectedAccount!);
        }
      }
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
    return Container(
      child: (_accounts != null && _accounts!.isNotEmpty)
          ? Row(
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
                    items: _accounts
                        ?.map<DropdownMenuItem<Account>>((Account account) {
                      return DropdownMenuItem<Account>(
                        value: account,
                        child: AccountTextWithIcon(account),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )
          : Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "account");
                },
                child: const Text("No accounts found\nClick here to add one",
                    textAlign: TextAlign.center),
              ),
            ),
    );
  }
}
