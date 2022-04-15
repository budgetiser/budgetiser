import 'package:budgetiser/shared/dataClasses/account.dart';
import 'package:budgetiser/shared/tempData/tempData.dart';
import 'package:flutter/material.dart';

class SelectAccount extends StatefulWidget {
  SelectAccount({
    Key? key,
    this.initialAccount,
  }) : super(key: key);
  Account? initialAccount;

  @override
  _SelectAccountState createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  final List<String> _accounts =
      TMP_DATA_accountList.map((e) => e.name).toList();
  String dropdownValue = TMP_DATA_accountList[0].name;

  @override
  void initState() {
    if (widget.initialAccount != null) {
      dropdownValue = widget.initialAccount!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Account:"),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: dropdownValue,
          elevation: 16,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: _accounts.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
