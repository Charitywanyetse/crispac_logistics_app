// lib/providers/dashboard_provider.dart

import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();
  
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
  }
  
  void refresh() {
    loadDashboardData();
  }
}