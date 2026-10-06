import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for Flutter Web / Windows desktop build
  // Note: For Android Emulator, change 'localhost' to '10.0.2.2'
  static const String baseUrl ='https://epcst-backend.onrender.com/api';

  // 1. Standard Gmail / Student ID & Password Login
  static Future<Map<String, dynamic>> login(String identifier, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': identifier.trim(),
        'password': password.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data; // Returns map with 'message', 'token', and 'user' map
    } else {
      throw Exception(data['error'] ?? 'Login failed. Please try again.');
    }
  }

  // 2. Google OAuth Login Request
  static Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['error'] ?? 'Google authentication failed.');
    }
  }

  // 3. Register New User Account
  static Future<Map<String, dynamic>> register({
    required String studentId,
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'studentId': studentId.trim(),
        'fullName': fullName.trim(),
        'email': email.trim(),
        'password': password.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['error'] ?? 'Registration failed.');
    }
  }

  // 4. Fetch Billing Details by User ID
  static Future<List<dynamic>> getBilling(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/billing/$userId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load billing records.');
    }
  }

  // 5. Fetch Merchandise Details
  static Future<List<dynamic>> getMerchandise() async {
    final response = await http.get(
      Uri.parse('$baseUrl/merch'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load merchandise records.');
    }
  }
}