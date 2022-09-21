import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/shared/dataClasses/transactionCategory.dart';
import 'package:flutter/material.dart';

class CategoryPicker extends StatefulWidget {
  const CategoryPicker({
    Key? key,
    required this.onCategoryPickedCallback,
    this.initialCategories,
  }) : super(key: key);

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
  final Function(List<TransactionCategory>) onCategoryPickedCallback;
  final List<TransactionCategory>? initialCategories;
}

class _CategoryPickerState extends State<CategoryPicker> {
  List<TransactionCategory> _selected = [];

  var scrollController = ScrollController();

  @override
  void initState() {
    if (widget.initialCategories != null) {
      _selected = widget.initialCategories!;
    }
    DatabaseHelper.instance.pushGetAllCategoriesStream();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      child: InkWell(
          borderRadius: BorderRadius.circular(15),
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
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
                            DatabaseHelper.instance
                                .pushGetAllCategoriesStream();
                            return AlertDialog(
                              title: const Text('Select categories'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: StreamBuilder<List<TransactionCategory>>(
                                  stream:
                                      DatabaseHelper.instance.allCategoryStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        itemBuilder: (context, j) {
                                          return StatefulBuilder(
                                              builder: (context,
                                                      localSetState) =>
                                                  CheckboxListTile(
                                                    title: Row(
                                                      children: [
                                                        Icon(
                                                          snapshot
                                                              .data![j].icon,
                                                          color: snapshot
                                                              .data![j].color,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            snapshot
                                                                .data![j].name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color: snapshot
                                                                  .data![j]
                                                                  .color,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    value: _selected.contains(
                                                        snapshot.data![j]),
                                                    onChanged: (bool? value) {
                                                      localSetState(() {
                                                        if (value == true) {
                                                          _selected.add(snapshot
                                                              .data![j]);
                                                        } else {
                                                          _selected.remove(
                                                              snapshot
                                                                  .data![j]);
                                                        }
                                                      });
                                                    },
                                                  ));
                                        },
                                        itemCount: snapshot.data!.length,
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("Oops!");
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
                                      widget
                                          .onCategoryPickedCallback(_selected);
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
                          widget.onCategoryPickedCallback(_selected);
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
              itemCount: (_selected.length) + 1,
            ),
          )),
    );
  }
}
