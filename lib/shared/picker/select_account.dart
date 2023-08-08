import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/db/recently_used.dart';
import 'package:budgetiser/screens/account/account_form.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/widgets/smallStuff/account_text_with_icon.dart';
import 'package:flutter/material.dart';

/// Account selector dropdown
///
/// TODO: validate form when no account is available
///
/// [blackListAccountId] account to not show in dropdown
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
  List<Account> _accounts = [];
  List<Account> _filteredAccounts = []; // account list with blacklist applied
  Account? _selectedAccount;
  final recentlyUsedAccount = RecentlyUsed<Account>();

  @override
  void initState() {
    DatabaseHelper.instance.allAccountsStream.listen((event) async {
      _accounts = event;
      _filteredAccounts = _accounts
          .where((element) => element.id != widget.blackListAccountId)
          .toList();

      if (_filteredAccounts.isEmpty) {
        return;
      }
      _selectedAccount = _filteredAccounts.first;

      List<int> filteredIDs = _filteredAccounts.map((e) => e.id).toList();
      if (widget.initialAccount != null &&
          filteredIDs.contains(widget.initialAccount!.id)) {
        _selectedAccount = _filteredAccounts
            .firstWhere((element) => element.id == widget.initialAccount!.id);
      } else {
        int? accountId =
            await recentlyUsedAccount.getLastUsed().then((value) => value?.id);
        if (accountId != null) {
          try {
            _selectedAccount = _filteredAccounts
                .firstWhere((element) => element.id == accountId);
          } catch (e) {
            // recently used not in filtered accounts (e.g. when blacklisted)
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
    String errorText = 'Create account';
    if (_filteredAccounts.isEmpty && _accounts.isNotEmpty) {
      errorText = 'Create 2nd account';
    }

    if (_filteredAccounts.isEmpty) {
      return Center(
        child: FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AccountForm(),
              ),
            );
          },
          label: Text(errorText),
          extendedTextStyle: const TextStyle(fontSize: 18),
        ),
      );
    }
    _filteredAccounts = _accounts
        .where((element) => element.id != widget.blackListAccountId)
        .toList();
    if (mounted && !_filteredAccounts.contains(_selectedAccount)) {
      _selectedAccount = _filteredAccounts.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.callback(_selectedAccount!);
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
        },
        items: _filteredAccounts.map<DropdownMenuItem<Account>>((
          Account account,
        ) {
          return DropdownMenuItem<Account>(
            value: account,
            child: AccountTextWithIcon(account),
          );
        }).toList(),
      ),
    );
  }
}
