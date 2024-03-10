// main.dart

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'create_account.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/createAccount': (context) => CreateAccountPage(),
      },
    );
  }
}
