// lib/services/dashboard_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  // FOR ANDROID EMULATOR: 10.0.2.2 points to your computer's localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // FOR PHYSICAL DEVICE: Use your computer's IP address
  // static const String baseUrl = 'http://192.168.1.100:8000/api';

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      print('🔑 Token: $token'); // Debug print

      if (token == null) {
        throw Exception('Not authenticated - Please login first');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Session expired - Please login again');
      } else {
        throw Exception('Failed to load dashboard: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Network error: $e');
    }
  }
}