import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://www.attitudetallyacademy.com/mobile/app';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login.php');
    final response = await http.post(url, body: {
      'username': username,
      'password': password,
    });
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    final url = Uri.parse('$baseUrl/user/profile');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token'
    });
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getCourses(String token) async {
    final url = Uri.parse('$baseUrl/user/course_list.php');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token'
    });
    return jsonDecode(response.body);
  }
}
