import 'package:attendanceapp/login.dart';
import 'package:attendanceapp/register.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xcc004343),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'View',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 36,
                          color: Colors.white),
                    ),
                    Text(
                      'Manage',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 36,
                          color: Colors.white),
                    ),
                    Text(
                      'Scan',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 36,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'QR code attendance taking,',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Text(
                      'Students managing their details.',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: ButtonTheme(
                          minWidth: 300.0,
                          height: 60.0,
                          child: RaisedButton(
                            color: Color(0xff505050),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xff505050),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                            ),
                            child: Text("Log In"),
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: ButtonTheme(
                          minWidth: 300.0,
                          height: 60.0,
                          child: RaisedButton(
                            color: Color(0xffF8F9D3),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xffF8F9D3),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                            ),
                            child: Text("Register"),
                            textColor: Color(0xcc004343),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()),
                              );
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
    );
  }
}
