import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/transactions/multi_step_form/multi_step_element.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSelectionHeader extends MultiStepHeader {
  const AccountSelectionHeader({super.key, required super.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        'This is a very long text to test overflow of step titles',
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AccountSelectionStep extends MultiStepElement {
  const AccountSelectionStep({super.key})
      : super(const AccountSelectionHeader(isSelected: true));

  @override
  Widget build(BuildContext context) {
    return AccountSelectionFormField();
  }
}

/// Complex form field for selecting two accounts, distinguishing betweem
/// an account from which money should be TAKEN, and one account to which
/// money should be GIVEN.
///
/// Short taps on account items select/deselect the TAKING account.
/// Long presses on account items select/deselect the RECEVING account.
///
/// The current selection is passed as a tuple (spendingAccount, receivingAccount)
/// to the [onChanged] callback.
class AccountSelectionFormField extends FormField<(Account?, Account?)> {
  AccountSelectionFormField(
      {super.key,
      ValueChanged<(Account?, Account?)>? onChanged,
      super.validator,
      super.autovalidateMode})
      : super(
          initialValue: (null, null),
          builder: (state) {
            void onChangedHandler((Account?, Account?) value) {
              state.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            return _AccountSelectionField(onChanged: onChangedHandler);
          },
        );
}

class _AccountSelectionField extends StatefulWidget {
  const _AccountSelectionField({super.key, this.onChanged});

  final ValueChanged<(Account?, Account?)>? onChanged;

  @override
  State<_AccountSelectionField> createState() => _AccountSelectionFieldState();
}

class _AccountSelectionFieldState extends State<_AccountSelectionField> {
  late Future<List<Account>> _accountsFuture;

  @override
  void initState() {
    super.initState();
    _accountsFuture =
        Provider.of<AccountModel>(context, listen: false).getAllAccounts();
  }

  /// Selected account from which the money should be TAKEN.
  Account? spendingAccount;

  /// Selected account to which the money should be GIVEN.
  Account? receivingAccount;

  /// Handle short taps on account items.
  /// Selected account is set as [spendingAccount]. If the tapped account
  /// is already selected as [spendingAccount], it will be deselected.
  /// If the tapped account is selected as [receivingAccount], and no
  /// [spendingAccount] is selected, the tapped account will be set as
  /// [spendingAccount] and [receivingAccount] will be deselected.
  void _onAccountTap(Account account) {
    setState(() {
      if (account == spendingAccount) {
        spendingAccount = null;
      } else if (account == receivingAccount) {
        if (spendingAccount == null) {
          spendingAccount = account;
          receivingAccount = null;
        }
      } else {
        spendingAccount = account;
      }
    });
    widget.onChanged?.call((spendingAccount, receivingAccount));
  }

  /// Handle long presses on account items.
  /// Selected account is set as [receivingAccount]. If the tapped account
  /// is already selected as [receivingAccount], it will be deselected.
  /// If the tapped account is selected as [spendingAccount], and no
  /// [receivingAccount] is selected, the tapped account will be set as
  /// [receivingAccount] and [spendingAccount] will be deselected.
  void _onAccountLongPress(Account account) {
    // Select receivingAccount
    setState(() {
      if (account == receivingAccount) {
        receivingAccount = null;
      } else if (account == spendingAccount) {
        if (receivingAccount == null) {
          receivingAccount = account;
          spendingAccount = null;
        }
      } else {
        receivingAccount = account;
      }
    });
    widget.onChanged?.call((spendingAccount, receivingAccount));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Account>>(
      future: _accountsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Fehler beim Laden der Konten'));
        }
        final accounts = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final account = accounts[index];
            return GestureDetector(
              onTap: () => _onAccountTap(account),
              onLongPress: () => _onAccountLongPress(account),
              child: _AccountTile(
                  account: account,
                  isSpendingAccount: account == spendingAccount,
                  isReceivingAccount: account == receivingAccount),
            );
          },
        );
      },
    );
  }
}

/// Visual representation of an account item in the account selection list.
class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.account,
    required this.isSpendingAccount,
    required this.isReceivingAccount,
  });

  final Account account;
  final bool isSpendingAccount;
  final bool isReceivingAccount;

  /// Get trailing icon for account item.
  /// If the account is selected as [spendingAccount], a red "call_made" icon
  /// is returned. If the account is selected as [receivingAccount], a
  /// green "call_received" icon is returned. Otherwise null is returned.
  Icon? getTrailingIcon(Account account) {
    if (isSpendingAccount) {
      return const Icon(
        Icons.call_made,
        color: Colors.red,
      );
    } else if (isReceivingAccount) {
      return const Icon(
        Icons.call_received,
        color: Colors.green,
      );
    }
    return null;
  }

  /// Get box decoration for account item.
  BoxDecoration getBoxDecoration(Account account) {
    return BoxDecoration(
      border: Border.all(
        color: account.color,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: getBoxDecoration(account),
      child: ListTile(
        leading: Icon(
          account.icon,
          color: account.color,
        ),
        title: Text(
          account.name,
          style: TextStyle(color: account.color),
        ),
        subtitle:
            account.description != null ? Text(account.description!) : null,
        trailing: getTrailingIcon(account),
      ),
    );
  }
}
