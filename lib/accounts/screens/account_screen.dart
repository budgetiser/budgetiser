import 'package:budgetiser/accounts/screens/account_form.dart';
import 'package:budgetiser/accounts/widgets/account_item.dart';
import 'package:budgetiser/core/database/models/account.dart';
import 'package:budgetiser/core/database/provider/account_provider.dart';
import 'package:budgetiser/core/drawer.dart';
import 'package:budgetiser/shared/widgets/list_views/item_list_divider.dart';
import 'package:budgetiser/shared/widgets/sort_by.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  static String routeID = 'account';
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late SortedByEnum currentSort = SortedByEnum.numberDescending;

  @override
  void initState() {
    initAsync();
    super.initState();
  }

  void initAsync() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      if (preferences.getString('key-account-screen-sorted-by') != null) {
        currentSort = stringToEnumSortedByEnum(
            preferences.getString('key-account-screen-sorted-by')!);
      }
    });
  }

  int sortFunction(Account a, Account b) {
    switch (currentSort) {
      case SortedByEnum.nameDescending:
        return b.name.compareTo(a.name);
      case SortedByEnum.nameAscending:
        return a.name.compareTo(b.name);
      case SortedByEnum.numberDescending:
        return b.balance.compareTo(a.balance);
      case SortedByEnum.numberAscending:
        return a.balance.compareTo(b.balance);
      default:
        // by name
        return a.name.compareTo(b.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      drawer: const CreateDrawer(),
      body: screenContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AccountForm(),
            ),
          );
        },
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      actions: [
        SortByIconWidget(
          initialSort: currentSort,
          onChangedCallback: (value) async {
            setState(() {
              currentSort = value;
            });
            final preferences = await SharedPreferences.getInstance();
            preferences.setString(
                'key-account-screen-sorted-by', currentSort.toString());
          },
        )
      ],
      title: const Text(
        'Accounts',
      ),
    );
  }

  Widget screenContent() {
    return Consumer<AccountModel>(
      builder: (context, value, child) {
        return FutureBuilder<List<Account>>(
          future: AccountModel().getAllAccounts(),
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
            snapshot.data!.sort(sortFunction);
            return ListView.separated(
              separatorBuilder: (context, index) => const ItemListDivider(),
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.only(bottom: 80),
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
