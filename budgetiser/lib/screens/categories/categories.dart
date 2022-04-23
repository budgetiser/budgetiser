import 'package:budgetiser/screens/categories/newCategory.dart';
import 'package:budgetiser/shared/widgets/categoryItem.dart';
import 'package:flutter/material.dart';
import 'package:budgetiser/drawer.dart';

class Categories extends StatelessWidget {
  static String routeID = 'categories';

  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categories",
          // style: Theme.of(context).textTheme.caption,
        ),
      ),
      drawer: createDrawer(context),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: const [
            CategoryItem('1', 'ÖPNV', Icons.train, Colors.redAccent, false),
            CategoryItem('2', 'Lebensmittel und Unterhaltungskosten',
                Icons.shopping_cart, Colors.greenAccent, false),
            CategoryItem('3', 'Party', Icons.group, Colors.blueAccent, false),
            CategoryItem('4', 'Sport', Icons.sports_football_sharp,
                Colors.yellowAccent, true),
            CategoryItem('5', 'Reisen', Icons.airplanemode_active,
                Colors.purpleAccent, false),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewCategory()));
        },
        tooltip: 'New category',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
