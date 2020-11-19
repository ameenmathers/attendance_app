import 'package:attendanceapp/attendance.dart';
import 'package:attendanceapp/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String scanRes;
  String attendance = "Present";
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  void scan() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#004343', 'Cancel', true, ScanMode.QR);

    setState(() {
      scanRes = barcodeScanRes;
    });
  }

  void updateAttendance() async {
    setState(() {
      showSpinner = true;
    });

    try {
      Firestore.instance.collection('classes').document(scanRes).updateData({
        "attendance": attendance,
      });

      setState(() {
        showSpinner = false;
      });

      Fluttertoast.showToast(
          msg: "Scanned and Marked Present",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff004343),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scan",
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 250,
              ),
              Center(
                child: Text(
                  "Click submit after the barcode scan to mark attendance.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xcc004343),
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: ButtonTheme(
                    minWidth: 300.0,
                    height: 60.0,
                    child: RaisedButton(
                      color: Color(0xcc004343),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Color(0xcc004343),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(0.0),
                        ),
                      ),
                      child: Text("Submit"),
                      textColor: Colors.white,
                      onPressed: updateAttendance,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        backgroundColor: Color(0xffF8F9D3),
        child: Icon(
          Icons.camera_alt,
          color: Color(0xcc004343),
        ),
      ),
    );
  }
}
