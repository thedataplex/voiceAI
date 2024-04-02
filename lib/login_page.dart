// login_page.dart

import 'package:flutter/material.dart';
import 'package:login_app/speech_to_text.dart';
import 'backend_service.dart';
import 'webview_page.dart';
import 'speech_to_text.dart';


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
                if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => WebViewPage()),);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SpeechToTextPage()));
                  } else {
                    throw Exception('Failed to login');
                  }
                } catch (e) {
                  // Handle login failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to login: $e')),
                  );
                }
              } else {
                // If one or both fields are empty, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Both Username and Password are required')),
      );
    }
  },
              child: Text('Login'),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to create account page
                    Navigator.pushNamed(context, '/createAccount');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black, // Default text color
                        fontSize: 16, // Default font size
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Not Already Signed Up? '),
                        TextSpan(
                          text: 'SignUp',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
