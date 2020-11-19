import 'package:attendanceapp/login.dart';
import 'package:attendanceapp/main.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  String _error;

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Color(0xcc004343),
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: AutoSizeText(
                _error,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  final _photo =
      'https://firebasestorage.googleapis.com/v0/b/attendance-app-7f610.appspot.com/o/pic.png?alt=media&token=110d6516-c32b-441b-8f80-3a6405f7d892';

  bool showSpinner = false;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController nameInputController;
  TextEditingController phoneInputController;
  TextEditingController emailInputController;
  TextEditingController departmentInputController;
  TextEditingController courseInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  void initState() {
    nameInputController = new TextEditingController();
    phoneInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    departmentInputController = new TextEditingController();
    courseInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          size: 40,
                          color: Color(0xcc004343),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _registerFormKey,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          showAlert(),
                          Text(
                            "Register",
                            style: TextStyle(
                              color: Color(0xcc004343),
                              fontSize: 35,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  controller: nameInputController,
                                  validator: (value) {
                                    if (value.length < 3) {
                                      return "Please enter a valid name.";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffc67608))),
                                    filled: true,
                                    hintText: "Full Name",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusColor: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  controller: emailInputController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: emailValidator,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffc67608))),
                                    filled: true,
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusColor: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Phone Number';
                                    }
                                    return null;
                                  },
                                  controller: phoneInputController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.phone_android),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffc67608))),
                                    filled: true,
                                    hintText: "Phone Number",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusColor: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter Department';
                                    }
                                    return null;
                                  },
                                  controller: departmentInputController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.account_balance),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffc67608))),
                                    filled: true,
                                    hintText: "Department",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusColor: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter course';
                                    }
                                    return null;
                                  },
                                  controller: courseInputController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.school),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffc67608))),
                                    filled: true,
                                    hintText: "Course",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusColor: Colors.black,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  obscureText: true,
                                  controller: pwdInputController,
                                  validator: pwdValidator,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    border: UnderlineInputBorder(),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.white,
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 300,
                                child: TextFormField(
                                  obscureText: true,
                                  controller: confirmPwdInputController,
                                  validator: pwdValidator,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    border: UnderlineInputBorder(),
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusColor: Colors.white,
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 45,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: ButtonTheme(
                                minWidth: 300.0,
                                height: 60.0,
                                child: RaisedButton(
                                  color: Color(0xff004343),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Color(0xff004343),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(0.0),
                                    ),
                                  ),
                                  child: Text("Sign Up"),
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    setState(() {
                                      showSpinner = true;
                                    });

                                    try {
                                      if (_registerFormKey.currentState
                                          .validate()) {
                                        if (pwdInputController.text ==
                                            confirmPwdInputController.text) {
                                          FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                                  email:
                                                      emailInputController.text,
                                                  password:
                                                      pwdInputController.text)
                                              .then((currentUser) => Firestore
                                                  .instance
                                                  .collection("users")
                                                  .document(
                                                      currentUser.user.uid)
                                                  .setData({
                                                    "uid": currentUser.user.uid,
                                                    "name": nameInputController
                                                        .text,
                                                    "department":
                                                        departmentInputController
                                                            .text,
                                                    "course":
                                                        courseInputController
                                                            .text,
                                                    "email":
                                                        emailInputController
                                                            .text,
                                                    "phone":
                                                        phoneInputController
                                                            .text,
                                                    "photoUrl": _photo,
                                                    "role": 'student',
                                                    "note": '',
                                                  })
                                                  .then((result) => {
                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Login()),
                                                            (_) => false),
                                                        nameInputController
                                                            .clear(),
                                                        emailInputController
                                                            .clear(),
                                                        pwdInputController
                                                            .clear(),
                                                        confirmPwdInputController
                                                            .clear()
                                                      })
                                                  .catchError(
                                                      (err) => print(err)))
                                              .catchError((err) => print(err));

                                          setState(() {
                                            showSpinner = false;
                                          });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Error"),
                                                  content: Text(
                                                      "The passwords do not match"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                        }
                                      }

                                      setState(() {
                                        showSpinner = false;
                                      });
                                    } catch (e) {
                                      print(e);

                                      setState(() {
                                        showSpinner = false;
                                        _error = e.message;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Already have an account?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                },
                                child: Text(
                                  "Log In",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xcc004343),
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
