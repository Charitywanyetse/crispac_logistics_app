import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  static String getUrl() {
    return baseUrl;
  }
  
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  // ============= AUTHENTICATION =============
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${getUrl()}/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      print('Login Response: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        
        if (result['status'] == 'success') {
          final data = result['data'];
          final prefs = await SharedPreferences.getInstance();
          
          await prefs.setString('token', data['token']);
          await prefs.setString('user_email', data['user']['email']);
          await prefs.setString('user_name', data['user']['name']);
          await prefs.setString('user_role', data['user']['role']);
          await prefs.setBool('is_admin', data['user']['role'] == 'admin');
          
          return {'success': true, 'data': data};
        }
      }
      
      return {'success': false, 'message': 'Invalid credentials'};
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
  
  // ============= DASHBOARD =============
  
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/dashboard'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data['data'] ?? data};
      }
      return {'success': false, 'message': 'Failed to load dashboard'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // ============= ORDERS =============
  
  Future<Map<String, dynamic>> getOrders() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/orders'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data['data'] ?? data};
      }
      return {'success': false, 'message': 'Failed to load orders'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${getUrl()}/orders'),
        headers: headers,
        body: json.encode(orderData),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data['data'] ?? data};
      }
      return {'success': false, 'message': 'Failed to create order'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // ============= PRODUCTS =============
  
  Future<Map<String, dynamic>> getProducts() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/products'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data['data'] ?? data};
      }
      return {'success': false, 'message': 'Failed to load products'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // ============= PROFILE =============
  
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/profile'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data['data'] ?? data};
      }
      return {'success': false, 'message': 'Failed to load profile'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${getUrl()}/profile'),
        headers: headers,
        body: json.encode(profileData),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data['data'] ?? data};
      }
      return {'success': false, 'message': 'Failed to update profile'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // ============= EMAIL/SMS =============
  
  Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${getUrl()}/send-verification'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'message': data['message'] ?? 'Code sent'};
      }
      return {'success': false, 'message': 'Failed to send code'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('${getUrl()}/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'code': code,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'message': data['message'] ?? 'Code verified'};
      }
      return {'success': false, 'message': 'Invalid code'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // ============= LOGOUT =============
  
  Future<Map<String, dynamic>> logout() async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${getUrl()}/logout'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        return {'success': true, 'message': 'Logged out'};
      }
      return {'success': false, 'message': 'Logout failed'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}