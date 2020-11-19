import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddClass extends StatefulWidget {
  final String name;
  final String photoUrl;

  const AddClass({
    Key key,
    @required this.name,
    @required this.photoUrl,
  }) : super(key: key);
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String attendance = "Absent";
  bool showSpinner = false;
  String _error;
  String _date;
  String classCourse;

  Future<DocumentSnapshot> userDocumentSnapshot;

  Future<void> getUserDoc() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      try {
        print(' No internet => Loading from cache');
        var snapshot = Firestore.instance
            .collection('users')
            .document(uid)
            .get(source: Source.cache);

        setState(() {
          userDocumentSnapshot = snapshot;
        });
      } catch (e) {
        print(' No internet, error retrieving cache => Loading from server');
        var snapshot = Firestore.instance
            .collection('users')
            .document(uid)
            .get(source: Source.serverAndCache);
        setState(() {
          userDocumentSnapshot = snapshot;
        });
      }
    } else {
      print(' Internet => Loading from server');

      Firestore.instance
          .collection('users')
          .document(uid)
          .get(source: Source.serverAndCache)
          .then((onValue) {
        print('data from server');
        setState(() {
          print('data from server setState');

          userDocumentSnapshot = Future.sync(() => onValue);
        });
      });
      var snapshot = Firestore.instance
          .collection('users')
          .document(uid)
          .get(source: Source.cache);

      setState(() {
        print('cache data');
        userDocumentSnapshot = snapshot;
      });
    }
  }

  final GlobalKey<FormState> _addClassFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserDoc();
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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM').format(now);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xff004343),
        title: Text(
          'Add a Class',
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
                key: _addClassFormKey,
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 0.0, 10.0, 16.0),
                              child: Container(
                                width: 300,
                                height: 50,
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.white,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: new DropdownButtonFormField<String>(
                                      iconEnabledColor: Colors.grey,
                                      value: classCourse,
                                      validator: (String newValue) {
                                        if (newValue == null) {
                                          return 'Please enter Course';
                                        }
                                        return null;
                                      },
                                      hint: Text(
                                        'Class',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          classCourse = newValue;
                                        });
                                      },
                                      items: <String>[
                                        'Web Development',
                                        'Research Method',
                                        'System Design',
                                        'Statistics',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(
                                            value,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
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
                                      if (_addClassFormKey.currentState
                                          .validate()) {
                                        setState(() {
                                          showSpinner = true;
                                        });

                                        try {
                                          final FirebaseUser user =
                                              await _auth.currentUser();
                                          final uid = user.uid;

                                          DocumentReference document =
                                              await Firestore.instance
                                                  .collection('classes')
                                                  .add({});

                                          String documentId =
                                              document.documentID;

                                          Firestore.instance
                                              .collection('classes')
                                              .document('$uid:$documentId')
                                              .setData({
                                            "uid": uid,
                                            "cid": '$uid:$documentId',
                                            "class": classCourse,
                                            "name": widget.name,
                                            "photoUrl": widget.photoUrl,
                                            "date": formattedDate,
                                            "attendance": attendance,
                                          });

                                          setState(() {
                                            showSpinner = false;
                                          });

                                          Fluttertoast.showToast(
                                              msg: "Course Class Requested",
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
