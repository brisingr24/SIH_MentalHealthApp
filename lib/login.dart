import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

var userGL;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();



  var mailController = TextEditingController();
  var passController = TextEditingController();

  checkAuth() async {
    _auth.authStateChanges().listen((User? user) {
      userGL = user;
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        print('User is not signed in');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  register({String email = '', String pass = ''}) async {
    print("Email : $email and Pass: $pass");
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      try {
        UserCredential user = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      } catch (e) {
        print(e);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: mailController,
                      validator: (input) {
                        if (input!.length < 6) {
                          return 'Enter Email';
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Email', prefixIcon: Icon(Icons.mail)),
                      //onSaved: (input) => email = input!,
                    ),
                    TextFormField(
                      controller: passController,
                      validator: (input) {
                        if (input!.length < 4) {
                          return 'Password';
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      // onSaved:
                      // (input) => email = input!,
                    ),
                    RaisedButton(
                        child: Text("LOG IN"),
                        onPressed: () {
                          register(
                              email: mailController.text,
                              pass: passController.text);
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
