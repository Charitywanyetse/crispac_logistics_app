import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Use your actual Laravel URL
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  
  static String getUrl() {
    return baseUrl;
  }
  
  // Headers
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
  
  // Login
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
      
      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        
        // Save token and user data
        final prefs = await SharedPreferences.getInstance();
        
        // Handle different response structures
        String token = data['token'] ?? data['access_token'] ?? '';
        String userName = data['user']['name'] ?? data['name'] ?? email.split('@')[0];
        String userRole = data['user']['role'] ?? data['role'] ?? 'customer';
        
        await prefs.setString('token', token);
        await prefs.setString('user_email', email);
        await prefs.setString('user_name', userName);
        await prefs.setString('user_role', userRole);
        await prefs.setBool('is_admin', userRole == 'admin' || userRole == 'Administrator');
        
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // Get User (for authentication check)
  Future<Map<String, dynamic>> getUser() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/user'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to get user'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${getUrl()}/logout'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        // Clear stored data
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('user_email');
        await prefs.remove('user_name');
        await prefs.remove('user_role');
        await prefs.remove('is_admin');
        
        return {'success': true, 'message': 'Logged out successfully'};
      } else {
        return {'success': false, 'message': 'Logout failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // ============= CUSTOMER DASHBOARD =============
  
  // Get Customer Dashboard
  Future<Map<String, dynamic>> getCustomerDashboard() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/dashboard'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to load dashboard'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // ============= ADMIN DASHBOARD =============
  
  // Get Admin Dashboard
  Future<Map<String, dynamic>> getAdminDashboard() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/admin/dashboard'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to load admin dashboard'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // Get Products (Admin)
  Future<Map<String, dynamic>> getAdminProducts() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/admin/products'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to load products'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // Get Orders (Admin)
  Future<Map<String, dynamic>> getAdminOrders() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/admin/orders'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to load orders'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // Get Customers (Admin)
  Future<Map<String, dynamic>> getAdminCustomers() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/admin/customers'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to load customers'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // Get Inventory (Admin)
  Future<Map<String, dynamic>> getAdminInventory() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/admin/inventory'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to load inventory'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // Get Production (Admin)
  Future<Map<String, dynamic>> getAdminProduction() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/admin/production'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to load production data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // Get Finance (Admin)
  Future<Map<String, dynamic>> getAdminFinance() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/admin/finance'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to load finance data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
  
  // Get Reports (Admin)
  Future<Map<String, dynamic>> getAdminReports() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${getUrl()}/admin/reports'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to load reports'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}