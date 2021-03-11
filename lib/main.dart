// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/Screens/Welcome/welcome.dart';
import 'package:test_app/Validation/newPostValidation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewPostValidation(),
      child: MaterialApp(
        title: 'Registered Voter Forum',
        theme: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Color(0xFFD8D5CF)),
        home: Welcome(),
      ),
    );
  }
}
