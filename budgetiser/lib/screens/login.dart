import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/homeScreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _passcodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _passcodeController,
                  obscureText: true,
                  validator: (data) {
                    if (data!.isEmpty) {
                      return "Please enter a passcode";
                    }
                    try {
                      int.parse(data);
                    } catch (e) {
                      return "Please enter a valid passcode";
                    }
                    return null;
                  },
                  obscuringCharacter: "*",
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: false),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Passcode',
                      hintText: 'Enter secure passcode'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate() == true){
                      int verify = await DatabaseHelper.instance.login(int.parse(_passcodeController.text));
                      if(verify == 1){
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (_) => Home()));
                      }else {
                        _passcodeController.clear();
                      }
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.transparent, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.redAccent)),
                child: TextButton(
                  onPressed: () {
                    DatabaseHelper.instance.logout();
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.redAccent, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 130,
              ),
            ],
          ),
        ),
      ),

    );
  }
}
