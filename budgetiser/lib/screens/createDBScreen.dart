import 'package:budgetiser/db/database.dart';
import 'package:flutter/material.dart';

import 'homeScreen.dart';

class CreateDatabaseScreen extends StatelessWidget {
  CreateDatabaseScreen({Key? key}) : super(key: key);
  final _passcodeController = TextEditingController();
  final _repeatPasscodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Database"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  key: _passKey,
                  autofocus: true,
                  controller: _passcodeController,
                  obscureText: true,
                  validator: (data) {
                    if (data!.isEmpty || data.length < 4) {
                      return "Passcode must have at least 4 characters";
                    }
                    try {
                      int.parse(data);
                    } catch (e) {
                      return "Please enter a valid passcode";
                    }
                    return null;
                  },
                  obscuringCharacter: "*",
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Passcode',
                      hintText: 'Enter secure passcode'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  autofocus: true,
                  controller: _repeatPasscodeController,
                  obscureText: true,
                  validator: (data) {
                    if (data!.isEmpty) {
                      return "Please repeat the passcode";
                    }
                    try {
                      int.parse(data);
                      return data == _passKey.currentState!.value
                          ? null
                          : "Repeated Passcode should match passcode";
                    } catch (e) {
                      return "Please enter a valid passcode";
                    }
                  },
                  obscuringCharacter: "*",
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Repeat passcode',
                      hintText: 'Repeat secure passcode'),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() == true) {
                      int verify = await DatabaseHelper.instance
                          .createDatabase(_passcodeController.text);
                      if (verify == 1) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => const Home()));
                      }
                    }
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 130,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 250,
                      child: Text(
                        "Attention!\nIf you forget your passcode all data stored in the database will be lost!.",
                        style: TextStyle(color: Colors.grey),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
