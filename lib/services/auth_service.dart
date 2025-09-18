import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Change this to your actual API base URL
  static const String baseUrl = 'http://localhost/acadexa_app_one/api';
  
  // Check if email exists in database
  static Future<Map<String, dynamic>> checkEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/check_email.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email}),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to check email');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
  
  // Set password for user
  static Future<Map<String, dynamic>> setPassword(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/set_password.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to set password');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
  
  // Login user
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Making login request to: $baseUrl/login.php');
      print('Login data: email=$email, password=$password');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        return {'success': false, 'error': errorData['error'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Network error: $e');
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }
}
