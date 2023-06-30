import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/account/account_form.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/widgets/smallStuff/account_text_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Account selector dropdown
///
/// TODO: validate form when no account is available
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
  List<Account>? _accounts = [];
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
      var filteredAccounts = _accounts
          ?.where((element) => element.id != widget.blackListAccountId);
      if (filteredAccounts != null && filteredAccounts.isEmpty) {
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      if (widget.initialAccount != null) {
        try {
          _selectedAccount = filteredAccounts?.firstWhere(
              (element) => element.id == widget.initialAccount!.id);
        } catch (e) {
          prefs.remove(keySelectedAccount);
          _selectedAccount = filteredAccounts?.first;
        }
      } else {
        final accountId = prefs.getInt(keySelectedAccount);
        if (accountId == null) {
          _selectedAccount = filteredAccounts?.first;
        } else {
          try {
            _selectedAccount = filteredAccounts
                ?.firstWhere((element) => element.id == accountId);
          } catch (e) {
            prefs.remove(keySelectedAccount);
            _selectedAccount = filteredAccounts?.first;
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
    String errorText = "Create account";
    if (filteredAccounts != null &&
        filteredAccounts.isEmpty &&
        _accounts!.isNotEmpty) {
      errorText = "Create 2nd account";
    }

    if (_accounts == null) {
      return Container();
    }
    if (_accounts!.isEmpty ||
        filteredAccounts != null && filteredAccounts.isEmpty) {
      return Center(
        child: FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AccountForm()));
          },
          label: Text(errorText),
          extendedTextStyle: const TextStyle(fontSize: 18),
        ),
      );
    }
    // check if selected account is not in _accounts
    if (_selectedAccount != null &&
        filteredAccounts != null &&
        !filteredAccounts.contains(_selectedAccount)) {
      setState(() {
        _selectedAccount = filteredAccounts.first;

        // wait to not trigger rebuild before this build is finished
        Future.delayed(Duration.zero, () async {
          widget.callback(_selectedAccount!);
        });
      });
    }

    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton<Account>(
        isExpanded: true,
        value: _selectedAccount,
        borderRadius: BorderRadius.circular(10),
        elevation: 1,
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
        items:
            filteredAccounts?.map<DropdownMenuItem<Account>>((Account account) {
          return DropdownMenuItem<Account>(
            value: account,
            child: AccountTextWithIcon(account),
          );
        }).toList(),
      ),
    );
  }
}
