import 'package:flutter/material.dart';
import 'package:test_app/Screens/Login/login.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Welcome'),
      // ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Rally",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 96,
                  color: Color(0xFF4B4B4B),
                  fontFamily: 'Rufina'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Login();
                  },
                ));
              },
              child: Text("Login"),
            ),
            FlatButton(
              onPressed: null,
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
