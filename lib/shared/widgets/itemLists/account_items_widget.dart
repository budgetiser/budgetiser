import 'package:budgetiser/db/recently_used.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/widgets/itemLists/item_list_container.dart';
import 'package:budgetiser/shared/widgets/items/accountItem/account_item.dart';
import 'package:flutter/material.dart';

class AccountItemsWidget extends StatelessWidget {
  AccountItemsWidget({
    super.key,
  });

  final recentlyUsedAccount = RecentlyUsed<Account>();

  @override
  Widget build(BuildContext context) {
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
        return Container(
          height: snapshot.data!.length * 95 + (snapshot.data!.length - 1) * 21,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return ItemListContainer(
                child: AccountItem(
                  accountData: snapshot.data![index],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
