// create_account_page.dart

import 'package:flutter/material.dart';
import 'backend_service.dart';

class CreateAccountPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Account')),
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
                // Perform account creation
                // Add your account creation logic here
                 try {
                  bool success = await BackendService.register(usernameController.text, passwordController.text);
                  if (success) {
                    // Registration successful
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account created successfully')));
                  } else {
                    throw Exception('Failed to create account');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create account: $e')));
                }
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
