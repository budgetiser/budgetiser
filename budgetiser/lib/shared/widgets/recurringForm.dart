import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecurringForm extends StatefulWidget {
  bool isHidden;

  RecurringForm({Key? key, required bool this.isHidden}) : super(key: key);

  @override
  State<RecurringForm> createState() => _RecurringFormState();
}

enum Selections { fixedTurnus, everyInterval }

class _RecurringFormState extends State<RecurringForm> {
  Selections? _selected = Selections.fixedTurnus;
  var turnusController = TextEditingController();
  var intervalController = TextEditingController();
  var repetitionsController = TextEditingController();
  String fixedTurnusMode = "week";
  String intervalMode = "day";

  List<DropdownMenuItem<String>> get dropdownItemsTurnus {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("of a week"), value: "week"),
      DropdownMenuItem(child: Text("of a month"), value: "month"),
      DropdownMenuItem(child: Text("of a year"), value: "year"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItemsInterval {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("day"), value: "day"),
      DropdownMenuItem(child: Text("week"), value: "week"),
      DropdownMenuItem(child: Text("month"), value: "month"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isHidden) {
      return Container();
    } else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: <Widget>[
              Radio(
                onChanged: (Selections? value) {
                  setState(() {
                    _selected = value;
                  });
                },
                groupValue: _selected,
                value: Selections.fixedTurnus,
              ),
              const Text("always on: "),
              SizedBox(
                width: 40,
                height: 30,
                child: TextFormField(
                  controller: turnusController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              SizedBox(
                child: DropdownButton(
                  value: fixedTurnusMode,
                  items: dropdownItemsTurnus,
                  onChanged: (String? value) {
                    setState(() {
                      fixedTurnusMode = value!;
                    });
                  },
                ),
              )
            ]),
            Row(children: <Widget>[
              Radio(
                onChanged: (Selections? value) {
                  setState(() {
                    _selected = value;
                  });
                },
                groupValue: _selected,
                value: Selections.everyInterval,
              ),
              const Text("every: "),
              SizedBox(
                width: 40,
                height: 30,
                child: TextFormField(
                  controller: intervalController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                ),
              ),
              SizedBox(
                child: DropdownButton(
                  value: intervalMode,
                  items: dropdownItemsInterval,
                  onChanged: (String? value) {
                    setState(() {
                      intervalMode = value!;
                    });
                  },
                ),
              )
            ]),
            Row(
              children: [
                Text("Repetitions: "),
                SizedBox(
                  width: 40,
                  height: 30,
                  child: TextFormField(
                    controller: repetitionsController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text("Ends on:"),
              ],
            ),
          ]);
    }
  }
}
