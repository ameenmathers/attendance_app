import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  bool showSpinner = false;
  String _error;

  final GlobalKey<FormState> _addNoteFormKey = GlobalKey<FormState>();

  TextEditingController noteInputController;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    noteInputController = new TextEditingController();
  }

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

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xff004343),
        title: Text(
          'Add a Note',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: 450,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0))),
            child: SingleChildScrollView(
              child: Form(
                key: _addNoteFormKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        showAlert(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            showAlert(),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter note';
                                      }
                                      return null;
                                    },
                                    controller: noteInputController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffc67608))),
                                      filled: true,
                                      hintText: "Add A Note",
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
                              height: 45,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 0.0, 0.0),
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
                                    child: Text("Submit"),
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      if (_addNoteFormKey.currentState
                                          .validate()) {
                                        setState(() {
                                          showSpinner = true;
                                        });

                                        try {
                                          final FirebaseUser user =
                                              await _auth.currentUser();
                                          final uid = user.uid;

                                          Firestore.instance
                                              .collection('users')
                                              .document(uid)
                                              .updateData({
                                            "note": noteInputController.text,
                                          });

                                          setState(() {
                                            showSpinner = false;
                                          });

                                          Fluttertoast.showToast(
                                              msg: "Note Added",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Color(0xff004343),
                                              textColor: Colors.white,
                                              fontSize: 14.0);

                                          Navigator.pop(context);
                                        } catch (e) {
                                          setState(() {
                                            showSpinner = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg: "Something went wrong",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.redAccent,
                                              textColor: Colors.white,
                                              fontSize: 14.0);

                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
