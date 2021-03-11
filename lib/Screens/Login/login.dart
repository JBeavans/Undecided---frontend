import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:flutter/semantics.dart';
import 'package:test_app/Screens/Home/home.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 112,
        title: Text(
          'Login',
          style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: 'Rufina'),
        ),
        elevation: 1,
      ),
      body: Center(child: LoginForm()),
      backgroundColor: Colors.white,
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<int> _attemptLogin(name, password) async {
    final url = 'http://localhost:3000/users/name/' + name;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String pwOnFile = data['password'];
      if (pwOnFile == password) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Home(id: data['id']);
          },
        ));
        return data['id'];
      } else {
        throw Exception('Incorrect password');
      }
    } else {
      throw Exception("Couldn't find user");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
            controller: usernameController,
            decoration: InputDecoration(
                icon: Icon(Icons.person), hintText: "username")),
        TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility),
                hintText: "password")),
        FlatButton(
          onPressed: () {
            _attemptLogin(usernameController.text, passwordController.text);
          },
          child: Text("Login"),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            "Create Account",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
