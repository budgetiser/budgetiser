import 'package:budgetiser/screens/transactions/shared/transactionForm.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/drawer.dart';

class NewTransaction extends StatelessWidget {
  const NewTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Transaction"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: TransactionForm(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
    // DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       bottom: const TabBar(
    //         tabs: [
    //           Tab(text: "single"),
    //           Tab(text: "recurring"),
    //         ],
    //       ),
    //       title: const Text('New Transaction'),
    //     ),
    //     body: const TabBarView(
    //       children: [
    //         SingleChildScrollView(
    //           child:
    //            TransactionForm(),
    //         ),
    //         Icon(Icons.directions_transit),
    //       ],
    //     ),
    //     floatingActionButton: FloatingActionButton.extended(
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //       label: const Text("Save"),
    //       icon: const Icon(Icons.save),
    //     ),
    //   ),
    // );
  }
}
