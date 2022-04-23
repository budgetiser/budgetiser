import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:flutter/material.dart';

import '../tempData/tempData.dart';

class CategoryPicker extends StatefulWidget {
  const CategoryPicker({Key? key}) : super(key: key);

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  List<TransactionCategory> _selected = [];
  List<bool> _isChecked = [];
  List<TransactionCategory> _available = TMP_DATA_categoryList;

  var scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _available.sort((a, b) => a.name.compareTo(b.name));
    _isChecked = List<bool>.filled(_available.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
          borderRadius: BorderRadius.circular(15),
          child: Scrollbar(
            controller: scrollController,
            isAlwaysShown: true,
            radius: const Radius.elliptical(10, 20),
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            for (var i = 0; i < _available.length; i++) {
                              if (_selected.contains(_available[i])) {
                                _isChecked[i] = true;
                              } else {
                                _isChecked[i] = false;
                              }
                            }
                            return AlertDialog(
                              title: const Text('Select categories'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  itemBuilder: (context, j) {
                                    return StatefulBuilder(
                                        builder: (context, _setState) =>
                                            CheckboxListTile(
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    _available[j].icon,
                                                    color: _available[j].color,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      _available[j].name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color:
                                                            _available[j].color,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              value: _isChecked[j],
                                              onChanged: (bool? value) {
                                                _setState(() {
                                                  if (value == true) {
                                                    _isChecked[j] = true;
                                                    _selected
                                                        .add(_available[j]);
                                                  } else {
                                                    _isChecked[j] = false;
                                                    _selected.removeWhere(
                                                        (element) =>
                                                            element.id ==
                                                            _available[j].id);
                                                  }
                                                });
                                              },
                                            ));
                                  },
                                  itemCount: _available.length,
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    setState(() {
                                      _selected.sort(
                                          (a, b) => a.name.compareTo(b.name));
                                    });
                                    Navigator.of(context)
                                        .pop(); //dismiss the color picker
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: const ListTile(
                      leading: Icon(Icons.add),
                      iconColor: Colors.white,
                      title: Text("Add Category"),
                    ),
                  );
                } else if (_selected[i - 1].isHidden == false) {
                  return ListTile(
                    leading: Icon(_selected[i - 1].icon),
                    title: Text(_selected[i - 1].name),
                    iconColor: _selected[i - 1].color,
                    textColor: _selected[i - 1].color,
                    trailing: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        setState(() {
                          _selected.removeAt(i - 1);
                        });
                      },
                      child: const Icon(Icons.remove_circle_outline),
                    ),
                  );
                } else {
                  return const ListTile(
                    title: Text("hidden"),
                  );
                }
              },
              shrinkWrap: true,
              itemCount: _selected.length + 1,
            ),
          )),
      height: 225,
    );
  }
}
