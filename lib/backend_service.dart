import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  // static const String baseUrl = 'http://10.0.2.2:5000'; // Update with your Flask server URL
  // static const String baseUrl = 'http://localhost:5000'; // Update with your Flask server URL
  static const String baseUrl = 'http://127.0.0.1:5000/'; // Update with your Flask server URL
  

  static Future register(String username, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      return true; // Registration successful
    } else {
      throw Exception('Failed to register user');
    }
  }

  static Future login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true; // Login successful
    } else if (response.statusCode == 401) {
      throw Exception('Invalid username or password');
    } else {
      throw Exception('Failed to login');
    }
  }
   static Future<bool> saveRecord(String firstName, String lastName, String dob, String ssn, String zipCode) async {
    final url = Uri.parse('$baseUrl/save_record');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'dob': dob,
        'ssn': ssn,
        'zip_code': zipCode,
      }),
    );

    if (response.statusCode == 201) {
      return true; // Record saved successfully
    } else {
      throw Exception('Failed to save record');
    }
  }
}
