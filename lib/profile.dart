import 'package:attendanceapp/add-class.dart';
import 'package:attendanceapp/add-note.dart';
import 'package:attendanceapp/change-password.dart';
import 'package:attendanceapp/edit-profile.dart';
import 'package:attendanceapp/login.dart';
import 'package:attendanceapp/main.dart';
import 'package:attendanceapp/student-attendance.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String email;
  bool showSpinner = false;

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

  final _formKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserDoc();
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
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              color: Color(0xff004343),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FutureBuilder(
                    future: userDocumentSnapshot,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 55,
                                      height: 55,
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: new BoxDecoration(
                                        color: Colors.white, // border color
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          snapshot.data['photoUrl'],
                                        ),
                                        radius: 50.0,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    _auth.signOut();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.power_settings_new,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data['email'] == null
                                      ? ''
                                      : snapshot.data['email'].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data['name'] == null
                                      ? ''
                                      : snapshot.data['name'].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.play_arrow,
                                      color: Color(0xff77E6B6),
                                    ),
                                    Text(
                                      'Student',
                                      style: TextStyle(
                                        color: Color(0xff77E6B6),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  30.0, 20.0, 0.0, 0.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xff004343)),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 240.0, 0.0, 0.0),
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
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            showAlert(),
                            SizedBox(
                              height: 20,
                            ),
                            FutureBuilder<DocumentSnapshot>(
                                future: userDocumentSnapshot,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 0.0, 0.0, 0.0),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.school,
                                                    color: Color(0xff004343),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    'Course:',
                                                    style: TextStyle(
                                                      color: Color(0xff004343),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data['course'] ==
                                                            null
                                                        ? ''
                                                        : snapshot
                                                            .data['course']
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.account_balance,
                                                    color: Color(0xff004343),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    'Department:',
                                                    style: TextStyle(
                                                      color: Color(0xff004343),
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data[
                                                                'department'] ==
                                                            null
                                                        ? ''
                                                        : snapshot
                                                            .data['department']
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.phone,
                                                    color: Color(0xff004343),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    'Phone:',
                                                    style: TextStyle(
                                                      color: Color(0xff004343),
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data['phone'] ==
                                                            null
                                                        ? ''
                                                        : snapshot.data['phone']
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.note,
                                                        color:
                                                            Color(0xff004343),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        'Note:',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff004343),
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      snapshot.data['note'] ==
                                                              null
                                                          ? ''
                                                          : snapshot
                                                              .data['note']
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Color(0xff004343),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.person,
                                            color: Colors.black,
                                          ),
                                          title: Text('Personal Information',
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfile(
                                                    name: snapshot.data['name'],
                                                    phone:
                                                        snapshot.data['phone'],
                                                  ),
                                                ));
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.lock_outline,
                                            color: Colors.black,
                                          ),
                                          title: Text('Change Password',
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangePassword()),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.class_,
                                            color: Colors.black,
                                          ),
                                          title: Text('Add Class',
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddClass(
                                                        name: snapshot
                                                            .data['name'],
                                                        photoUrl: snapshot
                                                            .data['photoUrl'],
                                                      )),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.note_add,
                                            color: Colors.black,
                                          ),
                                          title: Text('Add Note',
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddNote()),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.list,
                                            color: Colors.black,
                                          ),
                                          title: Text('View My Attendance',
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentAttendancePage()),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.power_settings_new,
                                            color: Colors.black,
                                          ),
                                          title: Text('Log out',
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                          onTap: () {
                                            _auth.signOut();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyHomePage()),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
