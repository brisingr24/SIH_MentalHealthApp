import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:kiran_app/login.dart';
import 'package:kiran_app/register.dart';

import 'home.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: const Image(image: AssetImage("images/KIRAN.png"),),
            ),
            Container(
              height: 200,
              width: 300,
              color: Colors.indigo,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  RegisterPage()),
                    );
                  },child: const Text(
                    "Register into KIRAN",style: TextStyle(color: Colors.white,fontSize: 18),
                  ),color: Colors.green,),
                  RaisedButton(onPressed: (){
                  },child: const Text(
                      "Helpline Number",style: TextStyle(color: Colors.white,fontSize: 18)
                  ),color: Colors.green,),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Row(mainAxisAlignment:MainAxisAlignment.center,
              children:  [
                Text("Already Have an account?"),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: RaisedButton(
                    color: Colors.white,
                      child :  Text("Sign In",style: TextStyle(color: Colors.blue),),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  LoginPage()),
                        );
                      }),
                )
              ],
            ),
            const SizedBox(height: 20,),
            // SignInButton(
            //   Buttons.Google,
            //   text: "Sign up with Google",
            //   onPressed: () {},
            // )
          ],
        ),
      ),
    );
  }
}
