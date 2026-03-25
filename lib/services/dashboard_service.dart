import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';

class DashboardService {
  Future<Map<String, dynamic>> getDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/dashboard'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      // Token expired – clear storage and go to login
      await prefs.remove('token');
      throw Exception('Session expired');
    } else {
      throw Exception('Failed to load dashboard: ${response.statusCode}');
    }
  }
}