import 'package:budgetiser/screens/groups/editGroup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  const GroupItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const EditGroup()));
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Groupname"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.airport_shuttle,
                  size: 40,
                  color: Colors.blueAccent,
                ),
                const Icon(Icons.airport_shuttle,
                    size: 40, color: Colors.redAccent),
                const Icon(
                  Icons.airport_shuttle,
                  size: 40,
                  color: Colors.green,
                ),
                const Icon(
                  Icons.airport_shuttle,
                  size: 40,
                  color: Colors.yellow,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
