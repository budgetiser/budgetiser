import 'package:budgetiser/db/database.dart';
import 'package:budgetiser/screens/homeScreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var _passcodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _passcodeController,
                obscureText: true,
                obscuringCharacter: "*",
                keyboardType: TextInputType.numberWithOptions(
                    decimal: false),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Passcode',
                    hintText: 'Enter secure passcode'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  int verify = await DatabaseHelper.instance.login(int.parse(_passcodeController.text));
                  if(verify == 1){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Home()));
                  }else {
                    _passcodeController.clear();
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  DatabaseHelper.instance.logout();
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
