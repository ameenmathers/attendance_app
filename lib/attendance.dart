import 'dart:async';

import 'package:attendanceapp/login.dart';
import 'package:attendanceapp/scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
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
    QuerySnapshot querySnapshot =
        await _usersCollectionReference.getDocuments();

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
          "Student Attendance",
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
      drawer: Drawer(
        child: Container(
          color: Color(0xff004343),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              ListTile(
                leading: Text(
                  'Scan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanPage()),
                  );
                },
              ),
              ListTile(
                leading: Text(
                  'View Attendance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AttendancePage()),
                  );
                },
              ),
              ListTile(
                leading: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                onTap: () {
                  _auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              )
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xff004343),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                height: 50,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
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
    );
  }
}
