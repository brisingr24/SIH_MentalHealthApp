import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'dart:io';
import 'home.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var mailController = TextEditingController();
  var passController = TextEditingController();
  UploadTask? task;
  File? file;

  checkAuth() async {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.push(
          this.context,
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
        UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      } catch (e) {
        print(e);
      }
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() {
      file = File(path);
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    final filename = basename(file!.path);
    final destination = 'files/$filename';

    FirebaseApi.uploadFile(destination,file!);

  }

  @override
  Widget build(BuildContext context) {
    final fileName = file !=null? basename(file!.path) :'No File Selected';
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: const Image(image: AssetImage("images/KIRAN.png"),),
            ),
            SizedBox(height: 30,),
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
                    SizedBox(height: 30,),
                    RaisedButton(
                        child: Text("Select File"),
                        onPressed: () {
                          selectFile();
                        }),
                    Text(fileName,style: TextStyle(fontSize: 16),),
                    SizedBox(height: 30,),
                    RaisedButton(
                        child: Text("Upload File"),
                        onPressed: () {
                          uploadFile();
                        }),
                    SizedBox(height: 60,),
                    RaisedButton(
                        child: Text("REGISTER"),
                        onPressed: () {
                          register(
                              email: mailController.text,
                              pass: passController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  LoginPage()),
                          );
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

class FirebaseApi {
  static UploadTask? uploadFile(String destination,File file){

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch(e){
      return null;
    }
  }
}
