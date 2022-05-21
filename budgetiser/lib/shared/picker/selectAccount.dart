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
    this.blackListAccountId,
  }) : super(key: key);
  final Account? initialAccount;
  final Function(Account) callback;
  final int? blackListAccountId;

  @override
  _SelectAccountState createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  List<Account>? _accounts;
  Account? _selectedAccount;

  @override
  void initState() {
    DatabaseHelper.instance.allAccountsStream.listen((event) async {
      _accounts?.clear();
      _accounts = (event.map((e) => e).toList());
      if (widget.initialAccount != null) {
        _selectedAccount = _accounts
            ?.firstWhere((element) => element.id == widget.initialAccount!.id);
      } else {
        final prefs = await SharedPreferences.getInstance();
        final accountId = prefs.getInt('key-last-selected-account');
        if (accountId == null) {
          _selectedAccount = _accounts?.first;
        } else {
          _selectedAccount =
              _accounts?.firstWhere((element) => element.id == accountId);
        }
      }
      if (_selectedAccount != null) {
        if (mounted) {
          widget.callback(_selectedAccount!);
        }
      }
    });
    DatabaseHelper.instance.pushGetAllAccountsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _filterAccounts =
        _accounts?.where((element) => element.id != widget.blackListAccountId);
    String errorText = "No accounts found\nClick here to add one";
    if (_filterAccounts != null && _filterAccounts.isEmpty) {
      errorText = "You need a 2nd account\nClick here to add one";
    }

    if (_accounts == null ||
        _accounts!.isEmpty ||
        _filterAccounts != null && _filterAccounts.isEmpty) {
      return Center(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, "account");
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
        _filterAccounts != null &&
        !_filterAccounts.contains(_selectedAccount)) {
      setState(() {
        _selectedAccount = _filterAccounts.first;
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
                await prefs.setInt('key-last-selected-account', newValue.id);
              }
            },
            items: _filterAccounts
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
