import 'package:budgetiser/accounts/widgets/account_item.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/shared/services/recently_used.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountItemsWidget extends StatelessWidget {
  AccountItemsWidget({
    super.key,
  });

  final recentlyUsedAccount = RecentlyUsed<Account>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountModel>(
      builder: (context, model, child) {
        return FutureBuilder(
          future: recentlyUsedAccount.getList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Text('Oops!');
            }
            if (snapshot.data!.isEmpty) {
              return const SizedBox(
                height: 40,
                child: Center(
                  child: Text('no accounts used yet'),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 0),
              itemCount: snapshot.data!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return AccountItem(
                  accountData: snapshot.data![index],
                );
              },
            );
          },
        );
      },
    );
  }
}
