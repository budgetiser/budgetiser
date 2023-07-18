import 'package:budgetiser/screens/groups/group_form.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  const GroupItem({
    Key? key,
    required this.groupData,
  }) : super(key: key);

  final Group groupData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => GroupForm(
              initialGroup: groupData,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  groupData.icon,
                  color: groupData.color,
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    groupData.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      groupData.transactionCategories[index].icon,
                      color: groupData.transactionCategories[index].color,
                    ),
                  );
                },
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: groupData.transactionCategories.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
