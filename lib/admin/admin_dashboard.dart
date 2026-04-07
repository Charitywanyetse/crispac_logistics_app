
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/dashboard_service.dart';
import 'screens/dashboard_home_screen.dart';
import 'screens/products_management_screen.dart';
import 'screens/orders_management_screen.dart';
import 'screens/customers_management_screen.dart';
import 'screens/inventory_management_screen.dart';
import 'screens/production_tracking_screen.dart';
import 'screens/finance_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/support_screen.dart';
import 'screens/settings_screen.dart';




class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isCollapsed = false;
  String _adminName = 'Admin User';
  String _adminEmail = 'admin@crispac.com';

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard, 'title': 'Dashboard', 'screen': DashboardHomeScreen()},
    {'icon': Icons.shopping_bag, 'title': 'Products', 'screen': ProductsManagementScreen()},
    {'icon': Icons.inventory, 'title': 'Orders', 'screen': OrdersManagementScreen()},
    {'icon': Icons.people, 'title': 'Customers', 'screen': CustomersManagementScreen()},
    {'icon': Icons.warehouse, 'title': 'Inventory', 'screen': InventoryManagementScreen()},
    {'icon': Icons.factory, 'title': 'Production', 'screen': ProductionTrackingScreen()},
    {'icon': Icons.attach_money, 'title': 'Finance', 'screen': FinanceScreen()},
    {'icon': Icons.bar_chart, 'title': 'Reports', 'screen': ReportsScreen()},
    {'icon': Icons.support_agent, 'title': 'Support', 'screen': SupportScreen()},
    {'icon': Icons.settings, 'title': 'Settings', 'screen': SettingsScreen()},
  ];

  @override
  void initState() {
    super.initState();
    _loadAdminInfo();
  }

  Future<void> _loadAdminInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _adminName = prefs.getString('user_name') ?? 'Admin User';
      _adminEmail = prefs.getString('user_email') ?? 'admin@crispac.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isCollapsed ? 80 : 280,
            decoration: BoxDecoration(
              color: Color(0xFF1A1A2E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Logo Section
                _buildLogo(),
                Divider(color: Colors.white24, height: 1),
                // Navigation Menu
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      return _buildNavItem(
                        icon: _menuItems[index]['icon'],
                        title: _menuItems[index]['title'],
                        isSelected: _selectedIndex == index,
                        isCollapsed: _isCollapsed,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
                // Collapse Button
                _buildCollapseButton(),
                // User Info
                _buildUserInfo(),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: _menuItems[_selectedIndex]['screen'],
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF915BEE), Color(0xFF6B48FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.brush,
              size: _isCollapsed ? 30 : 40,
              color: Colors.white,
            ),
          ),
          if (!_isCollapsed) ...[
            SizedBox(height: 12),
            Text(
              'CRISPAC',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              'Tailoring Studio',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required bool isCollapsed,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF915BEE) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 24,
            ),
            if (!isCollapsed) ...[
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCollapseButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isCollapsed = !_isCollapsed;
        });
      },
      child: Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
              color: Colors.white70,
              size: 20,
            ),
            if (!_isCollapsed) ...[
              SizedBox(width: 8),
              Text(
                'Collapse',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white24)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: _isCollapsed ? 20 : 25,
            backgroundColor: Color(0xFF915BEE),
            child: Text(
              _adminName.isNotEmpty ? _adminName[0].toUpperCase() : 'A',
              style: TextStyle(color: Colors.white, fontSize: _isCollapsed ? 14 : 18),
            ),
          ),
          if (!_isCollapsed) ...[
            SizedBox(height: 8),
            Text(
              _adminName,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              _adminEmail,
              style: TextStyle(color: Colors.white54, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                _logout();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }

  void _logout() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user_role');
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      
      // Optional: Call logout API
      // await _dashboardService.logout();
      
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}