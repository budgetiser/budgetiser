import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/widgets/smallStuff/accountTextWithIcon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    DatabaseHelper.instance.allAccountsStream.listen((event) async {
      _accounts?.clear();
      _accounts = (event.map((e) => e).toList());
      if (widget.initialAccount != null) {
        selectedAccount = _accounts
            ?.firstWhere((element) => element.id == widget.initialAccount!.id);
      } else {
        final prefs = await SharedPreferences.getInstance();
        final accountId = prefs.getInt('key-last-selected-account');
        if (accountId == null) {
          selectedAccount = _accounts?.first;
        } else {
          selectedAccount =
              _accounts?.firstWhere((element) => element.id == accountId);
        }
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
                    onChanged: (Account? newValue) async {
                      setState(() {
                        widget.callback(newValue!);
                        selectedAccount = newValue;
                      });
                      if (newValue != null) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt(
                            'key-last-selected-account', newValue.id);
                      }
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
