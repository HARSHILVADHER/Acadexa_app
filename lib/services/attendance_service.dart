import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'temp_storage.dart';

class AttendanceService {
  static const String baseUrl = 'http://localhost/acadexa_app_one/api';
  
  static Future<Map<String, dynamic>> getAttendanceForDate(String date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email') ?? TempStorage.getUserEmail();
      
      if (email == null) {
        throw Exception('No user email found');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/attendance_unified.php?email=$email&date=$date'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('AttendanceService error: $e');
      throw Exception('Failed to fetch attendance: $e');
    }
  }
  
  static Future<Map<String, dynamic>> getOverallAttendance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email') ?? TempStorage.getUserEmail();
      
      if (email == null) {
        throw Exception('No user email found');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/attendance_unified.php?email=$email'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('AttendanceService error: $e');
      throw Exception('Failed to fetch attendance: $e');
    }
  }
}