import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'temp_storage.dart';

class UserService {
  static const String baseUrl = 'http://localhost/acadexa_app_one/api';
  
  static Future<String> getUserName() async {
    // First try temp storage
    String tempName = TempStorage.getUserName();
    if (tempName != 'User') {
      return tempName;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      
      if (email == null) {
        // Try temp storage email as fallback
        final tempEmail = TempStorage.getUserEmail();
        if (tempEmail == null) return 'User';
        
        final response = await http.post(
          Uri.parse('$baseUrl/get_user.php'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': tempEmail}),
        );
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final name = data['name'] ?? 'User';
          TempStorage.setUserName(name);
          return name;
        }
        return 'User';
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/get_user.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final name = data['name'] ?? 'User';
        TempStorage.setUserName(name);
        return name;
      }
      return 'User';
    } catch (e) {
      print('UserService error: $e');
      return TempStorage.getUserName();
    }
  }
  
  static Future<String> getBatchName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      print('getBatchName - SharedPreferences email: $email'); // Debug
      
      if (email == null) {
        final tempEmail = TempStorage.getUserEmail();
        print('getBatchName - TempStorage email: $tempEmail'); // Debug
        if (tempEmail == null) return '12 EM Science';
        
        final response = await http.post(
          Uri.parse('$baseUrl/get_batch.php'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': tempEmail}),
        );
        
        print('getBatchName - API response: ${response.body}'); // Debug
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return data['batch_name'] ?? '12 EM Science';
        }
        return '12 EM Science';
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/get_batch.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      
      print('getBatchName - API response: ${response.body}'); // Debug
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['batch_name'] ?? '12 EM Science';
      }
      return '12 EM Science';
    } catch (e) {
      print('UserService getBatchName error: $e');
      return '12 EM Science';
    }
  }
  
  static Future<Map<String, dynamic>> getStudentCountAndYear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email') ?? TempStorage.getUserEmail();
      
      if (email == null) return {'student_count': 0, 'year': '', 'mentor_name': '', 'students': []};
      
      final response = await http.post(
        Uri.parse('$baseUrl/get_students_year.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'student_count': data['student_count'] ?? 0,
          'year': data['year'] ?? '',
          'mentor_name': data['mentor_name'] ?? '',
          'students': data['students'] ?? []
        };
      }
      return {'student_count': 0, 'year': '', 'mentor_name': '', 'students': []};
    } catch (e) {
      print('UserService getStudentCountAndYear error: $e');
      return {'student_count': 0, 'year': '', 'mentor_name': '', 'students': []};
    }
  }
  
  static Future<int> getStudentCount() async {
    final result = await getStudentCountAndYear();
    return result['student_count'];
  }
  
  static Future<String> getClassYear() async {
    final result = await getStudentCountAndYear();
    return result['year'];
  }
  
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}