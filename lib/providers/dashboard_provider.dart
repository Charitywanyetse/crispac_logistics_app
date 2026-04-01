// lib/providers/dashboard_provider.dart

import 'package:flutter/material.dart';
// import 'package:crispac_logistics_app/services/dashboard_service.dart';

class DashboardProvider with ChangeNotifier {
  // final DashboardService _dashboardService = DashboardService(); // Not used for dummy data
  
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _dashboardData;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get dashboardData => _dashboardData;
  
  // Summary getters
  String get totalOrders => _dashboardData?['data']['summary']['total_orders'].toString() ?? '0';
  String get totalRevenue => _dashboardData?['data']['summary']['total_revenue']?.toString() ?? '0.00';
  String get totalCustomers => _dashboardData?['data']['summary']['total_customers'].toString() ?? '0';
  String get totalProducts => _dashboardData?['data']['summary']['total_products'].toString() ?? '0';
  String get todayOrders => _dashboardData?['data']['summary']['today_orders'].toString() ?? '0';
  String get todayRevenue => _dashboardData?['data']['summary']['today_revenue']?.toString() ?? '0.00';
  
  // Chart data
  List<dynamic> get monthlySales => _dashboardData?['data']['monthly_sales'] ?? [];
  List<dynamic> get recentOrders => _dashboardData?['data']['recent_orders'] ?? [];
  List<dynamic> get popularProducts => _dashboardData?['data']['popular_products'] ?? [];
  
  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    // Simulate a short network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Dummy data – adjust numbers as you like
    _dashboardData = {
      'data': {
        'summary': {
          'total_orders': 24,
          'total_revenue': 4520.00,
          'total_customers': 18,
          'total_products': 42,
          'today_orders': 5,
          'today_revenue': 890.00,
        },
        'monthly_sales': [
          {'month': 'Jan', 'total_sales': 4200},
          {'month': 'Feb', 'total_sales': 3800},
          {'month': 'Mar', 'total_sales': 5100},
          {'month': 'Apr', 'total_sales': 4800},
          {'month': 'May', 'total_sales': 6200},
          {'month': 'Jun', 'total_sales': 5900},
        ],
        'recent_orders': [
          {'order_number': 'ORD-001', 'customer_name': 'John Doe', 'status': 'Delivered', 'total': 120.00},
          {'order_number': 'ORD-002', 'customer_name': 'Jane Smith', 'status': 'Pending', 'total': 85.50},
          {'order_number': 'ORD-003', 'customer_name': 'Bob Johnson', 'status': 'Processing', 'total': 210.00},
          {'order_number': 'ORD-004', 'customer_name': 'Alice Brown', 'status': 'Delivered', 'total': 45.00},
          {'order_number': 'ORD-005', 'customer_name': 'Charlie Wilson', 'status': 'Pending', 'total': 175.00},
        ],
        'popular_products': [
          {'name': 'Product A', 'order_count': 24, 'stock': 45},
          {'name': 'Product B', 'order_count': 18, 'stock': 8},
          {'name': 'Product C', 'order_count': 12, 'stock': 3},
          {'name': 'Product D', 'order_count': 10, 'stock': 20},
          {'name': 'Product E', 'order_count': 8, 'stock': 15},
        ],
      }
    };
    
    _isLoading = false;
    notifyListeners();
    
    // Original real API call (commented out for now)
    /*
    try {
      final data = await _dashboardService.getDashboardData();
      _dashboardData = data;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
    */
  }
  
  void refresh() {
    loadDashboardData();
  }
}