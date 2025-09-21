import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'temp_storage.dart';

class ExamService {
  static const String baseUrl = 'http://localhost/acadexa_app_one/api';
  
  static Future<Map<String, dynamic>> getExams() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email') ?? TempStorage.getUserEmail();
      
      if (email == null) {
        throw Exception('No user email found');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/get_exams.php?email=$email'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('ExamService error: $e');
      throw Exception('Failed to fetch exams: $e');
    }
  }
}