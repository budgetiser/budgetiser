import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/shared/widgets/selectable/selectable_icon_with_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionFormAccountPicker extends StatelessWidget {
  final void Function(Account)? onAccountPicked;

  const TransactionFormAccountPicker({
    super.key,
    this.onAccountPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountModel>(
      builder: (context, model, child) {
        return FutureBuilder<List<Account>>(
          future: model.getAllAccounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Accounts'),
              );
            }
            if (snapshot.hasError) {
              return const Text('Oops!');
            }

            var accountList =
                snapshot.data!.where((element) => !element.archived).toList();
            var archivedAccountList =
                snapshot.data!.where((element) => element.archived).toList();

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: archivedAccountList.isEmpty
                        ? const EdgeInsets.only(bottom: 80)
                        : null,
                    itemCount: accountList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          if (onAccountPicked != null) {
                            onAccountPicked!(accountList[index]);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SelectableIconWithText(
                                  accountList[index],
                                  size: 30,
                                  coloredText: false,
                                ),
                                Text(
                                  (accountList[index].balance).toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ]),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
