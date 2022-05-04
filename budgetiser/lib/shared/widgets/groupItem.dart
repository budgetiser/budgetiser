import 'package:budgetiser/screens/groups/groupForm.dart';
import 'package:budgetiser/shared/dataClasses/group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  GroupItem({Key? key, required this.groupData}) : super(key: key);
  final Group groupData;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => GroupForm(initialGroup: groupData,)));
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
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
                      Text(groupData.name),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(8),
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
          ),
          const Divider(
            indent: 15,
            endIndent: 15,
          )
        ],
    );
  }
}
