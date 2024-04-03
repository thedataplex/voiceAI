import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;

  class BackendService {
  static String get baseUrl {
    // Automatically switch between local and production URLs
    if (foundation.kReleaseMode) {
      // Use the Heroku URL in release mode
      return 'https://voiceai-app-f156169b04de.herokuapp.com';
    } else {
      // Use the local server URL in debug mode
      // Change this URL as per your local development setup if necessary
      return 'http://127.0.0.1:5000';
    }
  }

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
