import 'package:budgetiser/db/database.dart';
import 'package:flutter/material.dart';
import 'package:budgetiser/shared/dataClasses/account.dart';

class AccountPicker extends StatefulWidget {
  const AccountPicker({
    Key? key,
    required this.onAccountPickedCallback,
    this.initialAccounts,
  }) : super(key: key);

  @override
  State<AccountPicker> createState() => _AccountPickerState();
  final Function(List<Account>) onAccountPickedCallback;
  final List<Account>? initialAccounts;
}

class _AccountPickerState extends State<AccountPicker> {
  List<Account> _selected = [];

  var scrollController = ScrollController();

  @override
  void initState() {
    if (widget.initialAccounts != null) {
      _selected = widget.initialAccounts!;
    }
    DatabaseHelper.instance.pushGetAllAccountsStream();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            DatabaseHelper.instance.pushGetAllAccountsStream();
            return AlertDialog(
              title: const Text('Select Accounts'),
              content: SizedBox(
                width: double.maxFinite,
                child: StreamBuilder<List<Account>>(
                  stream: DatabaseHelper.instance.allAccountsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, j) {
                          return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return CheckboxListTile(
                                  title: Row(
                                    children: [
                                      Icon(
                                        snapshot.data![j].icon,
                                        color: snapshot.data![j].color,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          snapshot.data![j].name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: snapshot.data![j].color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  value: _selected.contains(snapshot.data![j]),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        _selected.add(snapshot.data![j]);
                                      } else {
                                        _selected.remove(snapshot.data![j]);
                                      }
                                    });
                                  },
                                );
                              }
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Text("An error occurred!");
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                // child:
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () {
                    setState(() {
                      widget.onAccountPickedCallback(_selected);
                    });
                    Navigator.of(context).pop(); //dismiss the color picker
                  },
                ),
              ],
            );
          });
    },
    child: const ListTile(
      leading: Icon(Icons.add),
      iconColor: Colors.white,
      title: Text("Select Account"),
    ),
    );
  }
}
