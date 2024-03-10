// login_page.dart

import 'package:flutter/material.dart';
import 'backend_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username or Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Perform login
                  bool success = await BackendService.login(
                    usernameController.text,
                    passwordController.text,
                  );
                  if (success) {
                    // Login successful
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login successful')),
                    );
                  } else {
                    throw Exception('Failed to login');
                  }
                } catch (e) {
                  // Handle login failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to login: $e')),
                  );
                }
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to create account page
                Navigator.pushNamed(context, '/createAccount');
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
