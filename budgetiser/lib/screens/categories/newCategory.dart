import 'package:budgetiser/screens/categories/shared/categoryForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewCategory extends StatefulWidget {
  NewCategory({
    Key? key,
  }) : super(key: key);

  @override
  State<NewCategory> createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  Color selectedColor = Colors.blueAccent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Category"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CategoryForm(),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Pick a color!'),
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
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
        label: const Text("Add Category"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
