import 'package:budgetiser/screens/categories/shared/categoryForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditCategory extends StatefulWidget {
  final Color selectedColor;
  final String categoryTitle;
  const EditCategory({
    Key? key,
    required Color this.selectedColor,
    required String this.categoryTitle,
  }) : super(key: key);

  @override
  State<EditCategory> createState() =>
      _EditCategoryState(selectedColor, categoryTitle);
}

class _EditCategoryState extends State<EditCategory> {
  Color selectedColor = Colors.white;
  String categoryTitle = "";

  _EditCategoryState(this.selectedColor, this.categoryTitle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CategoryForm(initialName: categoryTitle),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: MaterialPicker(
                                pickerColor: selectedColor, //default color
                                onColorChanged: (Color color) {
                                  setState(() {
                                    selectedColor = color;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); //dismiss the color picker
                                },
                              ),
                            ],
                          );
                        });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 30,
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: selectedColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: const Text("Submit changes"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
