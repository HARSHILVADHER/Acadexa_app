import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'temp_storage.dart';

class StudyMaterialService {
  static const String baseUrl = 'http://localhost/acadexa_app_one/api';

  static Future<Map<String, dynamic>> getStudyMaterials({String? type}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email') ?? TempStorage.getUserEmail();
      
      if (email == null) {
        return {'success': false, 'message': 'User not logged in'};
      }

      final body = {'email': email};
      if (type != null) {
        body['type'] = type;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/get_study_materials.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'success': false, 'message': 'Failed to fetch materials'};
      }
    } catch (e) {
      print('StudyMaterialService error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  static Future<Map<String, dynamic>> downloadMaterial(int materialId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email') ?? TempStorage.getUserEmail();
      
      if (email == null) {
        return {'success': false, 'message': 'User not logged in'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/download_study_material.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'material_id': materialId,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'success': false, 'message': 'Failed to download material'};
      }
    } catch (e) {
      print('StudyMaterialService download error: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }
}