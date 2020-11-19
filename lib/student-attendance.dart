import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentAttendancePage extends StatefulWidget {
  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  List<DocumentSnapshot> _users;
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection("classes");

  @override
  void initState() {
    super.initState();
    _getUsers();
    getCurrentUser();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  TextEditingController searchController = new TextEditingController();
  String filter;

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

  Future<List<DocumentSnapshot>> getUsersList() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    QuerySnapshot querySnapshot = await _usersCollectionReference
        .where('uid', isEqualTo: uid)
        .getDocuments();

    return querySnapshot.documents;
  }

  Future<void> _getUsers() async {
    List<DocumentSnapshot> usersList = await getUsersList().then((v) {
      print(v);
      return Future.value(v);
    });

    setState(() {
      _users = usersList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Attendance",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff004343),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xff004343),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Tap Each Attendance to View Barcode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: _users != null
                    ? _buildUsersList()
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _users.length,
        itemBuilder: ((context, index) {
          return filter == null || filter == ""
              ? _buildUserListTile(
                  userDataMap: _users[index].data, context: context)
              : _users[index]
                      .data['name']
                      .toLowerCase()
                      .contains(filter.toLowerCase())
                  ? _buildUserListTile(
                      userDataMap: _users[index].data, context: context)
                  : SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildUserListTile(
      {@required Map userDataMap, @required BuildContext context}) {
    return ListTile(
      leading: Container(
        child: userDataMap['photoUrl'] == null
            ? Text('')
            : CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(userDataMap['photoUrl']),
              ),
      ),
      title: Text(userDataMap['name'] == null ? '' : userDataMap['name'],
          style: TextStyle(
            color: Colors.white,
          )),
      subtitle: Text(
          userDataMap['attendance'] == null ? '' : userDataMap['attendance'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          )),
      trailing: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(userDataMap['class'] == null ? '' : userDataMap['class'],
              style: TextStyle(
                color: Colors.white,
              )),
          Text(userDataMap['date'] == null ? '' : userDataMap['date'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              )),
        ],
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (builder) {
              return Container(
                child: Center(
                  child: QrImage(
                    data: userDataMap['cid'],
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
                padding: EdgeInsets.all(40.0),
              );
            });
      },
    );
  }
}
