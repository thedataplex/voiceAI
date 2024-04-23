import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;


  // class BackendService {
  // static String get baseUrl {
  //   // Automatically switch between local and production URLs
  //   if (foundation.kReleaseMode) {
  //     // Use the Heroku URL in release mode
  //     return 'https://voiceai-app-f156169b04de.herokuapp.com';
  //   } else {
  //     if (Platform.isAndroid) {
  //       // Use the local server URL in debug mode
  //       // Change this URL as per your local development setup if necessary
  //       return 'http://10.0.2.2:5000'; // Android emulator
  //   } 
  //   else {
  //     // Use the local server URL in debug mode
  //     // Change this URL as per your local development setup if necessary
  //     return 'http://127.0.0.1:5000';
  //   }
  // }
  // }

  // class BackendService {
  // static String get baseUrl {
  //   // When running on the web, decide based on the release mode
  //   if (kIsWeb) {
  //     return kReleaseMode
  //         ? 'https://voiceai-app-f156169b04de.herokuapp.com' // Production URL for web release
  //         : 'http://127.0.0.1:5000'; // Local server URL for web debug
  //   } 
  //   // For Android emulator in debug mode
  //   else if (!kIsWeb && !kReleaseMode && Platform.isAndroid) {
  //     return 'http://10.0.2.2:5000'; // Special IP for Android emulator
  //   } 
  //   // Fallback for other non-web cases, including debug mode on devices other than Android emulator
  //   else {
  //     return 'http://127.0.0.1:5000'; // Local server URL
  //   }
  // }

  // class BackendService {
  // static String get baseUrl {
  //   // Always use the production URL in release mode for all platforms
  //   if (kReleaseMode) {
  //     return 'https://voiceai-app-f156169b04de.herokuapp.com';
  //   }
  //   // Special handling for Android emulator in debug mode
  //   else if (Platform.isAndroid) {
  //     return 'http://10.0.2.2:5000';
  //   }
  //   // Fallback for other cases in debug mode, e.g., iOS simulator or physical Android devices
  //   else {
  //     return 'http://127.0.0.1:5000';
  //   }
  // }

  class BackendService {
  static String get baseUrl {
    // Automatically switch between local and production URLs
    if (kIsWeb) {
      // For web deployments
      return kReleaseMode
          ? 'https://voiceai-app-f156169b04de.herokuapp.com' // Production URL for web release
          : 'http://127.0.0.1:5000'; // Local server URL for web debug
    } else if (Platform.isAndroid) {
      // For Android devices
      return kReleaseMode
          ? 'https://voiceai-app-f156169b04de.herokuapp.com' // Production URL for Android release
          : 'http://10.0.2.2:5000'; // Special IP for Android emulator in debug mode
    } else {
      // Fallback for other non-web cases
      return kReleaseMode ? 'https://voiceai-app-f156169b04de.herokuapp.com' : 'http://127.0.0.1:5000';
    }
  }

//   class BackendService{
//   static String get baseUrl {
//   return 'https://voiceai-app-f156169b04de.herokuapp.com'; // Always use production URL
// }
  



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
    // final url = Uri.parse('$baseUrl/save_record');
    final url = Uri.parse('https://voiceai-app-f156169b04de.herokuapp.com/save_record');
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
