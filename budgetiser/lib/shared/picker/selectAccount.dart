import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/account/accountForm.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/widgets/smallStuff/accountTextWithIcon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectAccount extends StatefulWidget {
  const SelectAccount({
    Key? key,
    this.initialAccount,
    required this.callback,
    this.blackListAccountId,
  }) : super(key: key);
  final Account? initialAccount;
  final Function(Account) callback;
  final int? blackListAccountId;

  @override
  State<SelectAccount> createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  List<Account>? _accounts;
  Account? _selectedAccount;
  final String keySelectedAccount = "key-last-selected-account";

  @override
  void initState() {
    DatabaseHelper.instance.allAccountsStream.listen((event) async {
      if (event.isEmpty) {
        return;
      }
      _accounts?.clear();
      _accounts = (event.map((e) => e).toList());
      final prefs = await SharedPreferences.getInstance();
      if (widget.initialAccount != null) {
        try {
          _selectedAccount = _accounts?.firstWhere(
              (element) => element.id == widget.initialAccount!.id);
        } catch (e) {
          prefs.remove(keySelectedAccount);
          _selectedAccount = _accounts?.first;
        }
      } else {
        final accountId = prefs.getInt(keySelectedAccount);
        if (accountId == null) {
          _selectedAccount = _accounts?.first;
        } else {
          try {
            _selectedAccount =
                _accounts?.firstWhere((element) => element.id == accountId);
          } catch (e) {
            prefs.remove(keySelectedAccount);
            _selectedAccount = _accounts?.first;
          }
        }
      }
      if (mounted && _selectedAccount != null) {
        widget.callback(_selectedAccount!);
      }
    });
    DatabaseHelper.instance.pushGetAllAccountsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filteredAccounts =
        _accounts?.where((element) => element.id != widget.blackListAccountId);
    String errorText = "No accounts found\nClick here to add one";
    if (filteredAccounts != null && filteredAccounts.isEmpty) {
      errorText = "You need a 2nd account\nClick here to add one";
    }

    if (_accounts == null ||
        _accounts!.isEmpty ||
        filteredAccounts != null && filteredAccounts.isEmpty) {
      return Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AccountForm()));
          },
          child: Text(
            errorText,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    // check if selected account is not in _accounts
    if (_selectedAccount != null &&
        filteredAccounts != null &&
        !filteredAccounts.contains(_selectedAccount)) {
      setState(() {
        _selectedAccount = filteredAccounts.first;
      });
    }

    Future(executeAfterBuild);
    return Row(
      children: [
        const Text("Account:"),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton<Account>(
            isExpanded: true,
            value: _selectedAccount,
            elevation: 16,
            onChanged: (Account? newValue) async {
              setState(() {
                widget.callback(newValue!);
                _selectedAccount = newValue;
              });
              if (newValue != null) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt(keySelectedAccount, newValue.id);
              }
            },
            items: filteredAccounts
                ?.map<DropdownMenuItem<Account>>((Account account) {
              return DropdownMenuItem<Account>(
                value: account,
                child: AccountTextWithIcon(account),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// executes after build is done by being called in a Future() from the build() method
  Future<void> executeAfterBuild() async {
    if (_selectedAccount != null) {
      widget.callback(_selectedAccount!);
    }
  }
}
