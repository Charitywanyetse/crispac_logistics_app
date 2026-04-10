// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Import your existing screens
import 'profile_screen.dart';
import 'settings_screen.dart';

// Simple Products Screen
class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text('Products', style: TextStyle(color: Color(0xFF8E2DE2))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 80, color: Color(0xFF8E2DE2).withOpacity(0.3)),
            SizedBox(height: 16),
            Text(
              'Products Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23)),
            ),
            SizedBox(height: 8),
            Text('Coming Soon', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// Simple Orders Screen
class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text('Orders', style: TextStyle(color: Color(0xFF8E2DE2))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 80, color: Color(0xFF8E2DE2).withOpacity(0.3)),
            SizedBox(height: 16),
            Text(
              'Orders Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23)),
            ),
            SizedBox(height: 8),
            Text('Coming Soon', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// Stats Screen
class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text('Statistics', style: TextStyle(color: Color(0xFF8E2DE2))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 80, color: Color(0xFF8E2DE2).withOpacity(0.3)),
            SizedBox(height: 16),
            Text(
              'Statistics & Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23)),
            ),
            SizedBox(height: 8),
            Text('Coming Soon', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// Support Screen
class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text('Support', style: TextStyle(color: Color(0xFF8E2DE2))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support Center',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1C23),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'How can we help you today?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 32),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildSupportCard(
                  icon: Icons.help_outline,
                  title: 'FAQ',
                  description: 'Frequently asked questions',
                  color: Color(0xFF6B48FF),
                ),
                _buildSupportCard(
                  icon: Icons.chat_outlined,
                  title: 'Live Chat',
                  description: 'Chat with support team',
                  color: Color(0xFF8E2DE2),
                ),
                _buildSupportCard(
                  icon: Icons.email_outlined,
                  title: 'Email Support',
                  description: 'crispac2@gmail.com',
                  color: Color(0xFFB27AFF),
                ),
                _buildSupportCard(
                  icon: Icons.phone_outlined,
                  title: 'Phone Support',
                  description: '+256 123 456789',
                  color: Color(0xFF6B48FF),
                ),
                _buildSupportCard(
                  icon: Icons.video_call_outlined,
                  title: 'Video Tutorials',
                  description: 'Watch guides',
                  color: Color(0xFF8E2DE2),
                ),
                _buildSupportCard(
                  icon: Icons.description_outlined,
                  title: 'Documentation',
                  description: 'API & Integration',
                  color: Color(0xFFB27AFF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Dashboard Screen
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;
  String _userName = 'Charity';
  String _userEmail = 'crispac2@gmail.com';
  String _userRole = 'Administrator';
  
  Map<String, dynamic> _dashboardData = {};
  bool _isLoading = true;
  
  final String _baseUrl = 'https://your-backend-api.com/api';
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchDashboardData();
  }
  
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Charity';
      _userEmail = prefs.getString('user_email') ?? 'crispac2@gmail.com';
      _userRole = prefs.getString('user_role') ?? 'Administrator';
    });
  }
  
  Future<void> _fetchDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      final response = await http.get(
        Uri.parse('$_baseUrl/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        setState(() {
          _dashboardData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        _loadMockData();
      }
    } catch (e) {
      _loadMockData();
    }
  }
  
  void _loadMockData() {
    setState(() {
      _dashboardData = {
        'total_orders': 156,
        'total_products': 42,
        'total_revenue': 125000.00,
        'total_customers': 89,
        'pending_orders': 12,
        'delivered_orders': 144,
        'recent_orders': [
          {'id': 'ORD-001', 'customer': 'John Doe', 'amount': 2500.00, 'status': 'pending'},
          {'id': 'ORD-002', 'customer': 'Jane Smith', 'amount': 1800.00, 'status': 'delivered'},
          {'id': 'ORD-003', 'customer': 'Mike Johnson', 'amount': 3200.00, 'status': 'shipped'},
          {'id': 'ORD-004', 'customer': 'Sarah Wilson', 'amount': 950.00, 'status': 'pending'},
          {'id': 'ORD-005', 'customer': 'David Brown', 'amount': 4200.00, 'status': 'delivered'},
        ],
        'top_products': [
          {'name': 'Cargo Service', 'sales': 45, 'revenue': 22500, 'growth': '+12%'},
          {'name': 'Express Delivery', 'sales': 38, 'revenue': 19000, 'growth': '+8%'},
          {'name': 'Warehouse Storage', 'sales': 30, 'revenue': 15000, 'growth': '+15%'},
          {'name': 'Freight Forwarding', 'sales': 25, 'revenue': 12500, 'growth': '+5%'},
        ],
      };
      _isLoading = false;
    });
  }
  
  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'index': 0},
    {'title': 'Products', 'icon': Icons.inventory_2, 'index': 1},
    {'title': 'Orders', 'icon': Icons.shopping_cart, 'index': 2},
    {'title': 'Statistics', 'icon': Icons.bar_chart, 'index': 3},
    {'title': 'Profile', 'icon': Icons.person, 'index': 4},
    {'title': 'Settings', 'icon': Icons.settings, 'index': 5},
    {'title': 'Support', 'icon': Icons.support_agent, 'index': 6},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }
  
  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: _isSidebarExpanded ? 280 : 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B48FF), Color(0xFF8E2DE2), Color(0xFFB27AFF)],
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(2, 0))],
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            child: Center(
              child: _isSidebarExpanded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping, size: 40, color: Colors.white),
                        SizedBox(height: 8),
                        Text('CRISPAC', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                        Text('Logistics', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    )
                  : Icon(Icons.local_shipping, size: 40, color: Colors.white),
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.2), height: 1),
          if (_isSidebarExpanded)
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF8E2DE2))),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_userName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                        Text(_userRole, style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _selectedIndex == item['index'];
                return InkWell(
                  onTap: () => setState(() => _selectedIndex = item['index']),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(item['icon'], color: Colors.white, size: 24),
                        if (_isSidebarExpanded) ...[SizedBox(width: 12), Text(item['title'], style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal))],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: IconButton(
              icon: Icon(_isSidebarExpanded ? Icons.chevron_left : Icons.chevron_right, color: Colors.white),
              onPressed: () => setState(() => _isSidebarExpanded = !_isSidebarExpanded),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0: return _buildDashboardContent();
      case 1: return ProductsScreen();
      case 2: return OrdersScreen();
      case 3: return StatsScreen();
      case 4: return ProfileScreen();
      case 5: return SettingsScreen();
      case 6: return SupportScreen();
      default: return _buildDashboardContent();
    }
  }
  
  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: _fetchDashboardData,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, $_userName!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C23),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Here\'s what\'s happening with your logistics today.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF6B48FF), Color(0xFF8E2DE2)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_none, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        DateFormat('MMM dd').format(DateTime.now()),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Stats Cards
            if (_isLoading)
              Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8E2DE2))))
            else
              _buildStatsGrid(),
            
            SizedBox(height: 24),
            
            // Recent Orders and Top Products
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildRecentOrders()),
                SizedBox(width: 20),
                Expanded(flex: 1, child: _buildTopProducts()),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsGrid() {
    final stats = [
      {'title': 'Total Orders', 'value': _dashboardData['total_orders'] ?? 0, 'icon': Icons.shopping_cart, 'color': Color(0xFF6B48FF)},
      {'title': 'Pending', 'value': _dashboardData['pending_orders'] ?? 0, 'icon': Icons.pending_actions, 'color': Color(0xFFFF9800)},
      {'title': 'Revenue', 'value': 'UGX ${(_dashboardData['total_revenue'] ?? 0).toStringAsFixed(0)}', 'icon': Icons.attach_money, 'color': Color(0xFF8E2DE2)},
      {'title': 'Customers', 'value': _dashboardData['total_customers'] ?? 0, 'icon': Icons.people, 'color': Color(0xFFB27AFF)},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: stat['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(stat['icon'], color: stat['color'], size: 22),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat['title'],
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 2),
                  Text(
                    stat['value'].toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildRecentOrders() {
    final orders = _dashboardData['recent_orders'] ?? [];
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23))),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 2),
                child: Text('View All', style: TextStyle(color: Color(0xFF8E2DE2), fontSize: 12)),
              ),
            ],
          ),
          SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orders.length > 4 ? 4 : orders.length,
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: _getStatusColor(order['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(_getStatusIcon(order['status']), color: _getStatusColor(order['status']), size: 18),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order['id'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(order['customer'], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('UGX ${NumberFormat('#,###').format(order['amount'])}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF8E2DE2))),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order['status']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(order['status'].toUpperCase(), style: TextStyle(fontSize: 9, color: _getStatusColor(order['status']), fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopProducts() {
    final products = _dashboardData['top_products'] ?? [];
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23))),
          SizedBox(height: 12),
          ...products.take(4).map((product) {
            final percentage = (product['sales'] / 50 * 100).toDouble();
            return Container(
              margin: EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(product['name'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                      ),
                      Text('UGX ${(product['revenue'] / 1000).toStringAsFixed(0)}K', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF8E2DE2))),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8E2DE2)),
                          minHeight: 4,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text('${product['sales']}', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                    ],
                  ),
                  Text(product['growth'], style: TextStyle(fontSize: 9, color: Colors.green)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return Colors.green;
      case 'shipped': return Colors.blue;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }
  
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return Icons.check_circle;
      case 'shipped': return Icons.local_shipping;
      case 'pending': return Icons.pending;
      default: return Icons.receipt;
    }
  }
}