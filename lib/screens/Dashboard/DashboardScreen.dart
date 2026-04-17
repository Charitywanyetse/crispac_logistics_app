// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'products_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

// ============= STATS SCREEN =============
class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: isMobile ? AppBar(
        title: Text('Statistics'),
        backgroundColor: Color(0xFF8E2DE2),
        foregroundColor: Colors.white,
        elevation: 0,
      ) : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 80, color: Color(0xFF8E2DE2).withOpacity(0.3)),
            SizedBox(height: 16),
            Text('Statistics feature coming soon', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            SizedBox(height: 8),
            Text('Your data analytics will appear here', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}

// ============= SUPPORT SCREEN =============
class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: isMobile ? AppBar(
        title: Text('Support'),
        backgroundColor: Color(0xFF8E2DE2),
        foregroundColor: Colors.white,
        elevation: 0,
      ) : null,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: isMobile ? 2 : 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildSupportCard(Icons.help_outline, 'FAQ', 'Frequently asked questions', Color(0xFF6B48FF)),
            _buildSupportCard(Icons.chat_outlined, 'Live Chat', 'Chat with support team', Color(0xFF8E2DE2)),
            _buildSupportCard(Icons.email_outlined, 'Email', 'crispac2@gmail.com', Color(0xFFB27AFF)),
            _buildSupportCard(Icons.phone_outlined, 'Phone', '+256 123 456789', Color(0xFF6B48FF)),
            _buildSupportCard(Icons.video_call_outlined, 'Tutorials', 'Watch guides', Color(0xFF8E2DE2)),
            _buildSupportCard(Icons.description_outlined, 'Docs', 'API & Integration', Color(0xFFB27AFF)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSupportCard(IconData icon, String title, String description, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 32)),
          SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600]), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ============= DASHBOARD SCREEN =============
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _userName = 'Charity';
  Map<String, dynamic> _dashboardData = {};
  bool _isLoading = true;
  bool _isMobile = false;
  
  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard, 'screen': 0},
    {'title': 'Products', 'icon': Icons.inventory_2, 'screen': 1},
    {'title': 'Orders', 'icon': Icons.shopping_cart, 'screen': 2},
    {'title': 'Statistics', 'icon': Icons.bar_chart, 'screen': 3},
    {'title': 'Profile', 'icon': Icons.person, 'screen': 4},
    {'title': 'Settings', 'icon': Icons.settings, 'screen': 5},
    {'title': 'Support', 'icon': Icons.support_agent, 'screen': 6},
  ];
  
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadMockData();
  }
  
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _userName = prefs.getString('user_name') ?? 'Charity');
  }
  
  void _loadMockData() {
    setState(() {
      _dashboardData = {
        'total_orders': 156, 'pending_orders': 12, 'total_revenue': 125000, 'total_customers': 89,
        'recent_orders': [
          {'id': 'ORD-001', 'customer': 'John Doe', 'amount': 2500, 'status': 'pending'},
          {'id': 'ORD-002', 'customer': 'Jane Smith', 'amount': 1800, 'status': 'delivered'},
          {'id': 'ORD-003', 'customer': 'Mike Johnson', 'amount': 3200, 'status': 'shipped'},
        ],
        'top_products': [
          {'name': 'Cargo Service', 'sales': 45, 'revenue': 22500, 'growth': '+12%'},
          {'name': 'Express Delivery', 'sales': 38, 'revenue': 19000, 'growth': '+8%'},
        ],
        'recent_activities': [
          {'action': 'New order created', 'details': 'Order #ORD-007', 'time': '5 min ago'},
          {'action': 'Shipment delivered', 'details': 'Order #ORD-002', 'time': '1 hour ago'},
        ],
      };
      _isLoading = false;
    });
  }
  
  Widget _getScreen(int index) {
    switch (index) {
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
  
  @override
  Widget build(BuildContext context) {
    _isMobile = MediaQuery.of(context).size.width < 800;
    
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      body: _isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }
  
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text(_menuItems[_selectedIndex]['title']),
        backgroundColor: Color(0xFF8E2DE2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _getScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Color(0xFF8E2DE2),
        unselectedItemColor: Colors.grey,
        items: _menuItems.map((item) => 
          BottomNavigationBarItem(icon: Icon(item['icon']), label: item['title'])
        ).toList(),
      ),
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Container(
          width: 260,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF6B48FF), Color(0xFF8E2DE2), Color(0xFFB27AFF)]),
          ),
          child: Column(
            children: [
              Container(height: 120, child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.local_shipping, size: 40, color: Colors.white), SizedBox(height: 8),
                Text('CRISPAC', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Logistics', style: TextStyle(fontSize: 12, color: Colors.white70))]))),
              Divider(color: Colors.white.withOpacity(0.2)),
              Container(padding: EdgeInsets.all(16), child: Row(children: [
                CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF8E2DE2))),
                SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_userName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Administrator', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ])),
              ])),
              Expanded(
                child: ListView.builder(
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    final isSelected = _selectedIndex == index;
                    return InkWell(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(children: [
                          Icon(item['icon'], color: Colors.white, size: 24),
                          SizedBox(width: 12),
                          Text(item['title'], style: TextStyle(color: Colors.white, fontSize: 14)),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(padding: EdgeInsets.all(24), child: _getScreen(_selectedIndex)),
        ),
      ],
    );
  }
  
  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF6B48FF), Color(0xFF8E2DE2)]), borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Welcome back, $_userName!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 4),
                Text('Here\'s what\'s happening with your logistics today.', style: TextStyle(fontSize: 13, color: Colors.white70)),
              ]),
              Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Icon(Icons.calendar_today, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(DateFormat('MMM dd, yyyy').format(DateTime.now()), style: TextStyle(color: Colors.white, fontSize: 12)),
                ]),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        
        if (_isLoading)
          Center(child: CircularProgressIndicator())
        else
          GridView.builder(
            shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _isMobile ? 2 : 4, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4),
            itemCount: 4,
            itemBuilder: (context, index) {
              final stats = [
                {'title': 'Total Orders', 'value': _dashboardData['total_orders'], 'icon': Icons.shopping_cart, 'color': Color(0xFF6B48FF)},
                {'title': 'Pending Orders', 'value': _dashboardData['pending_orders'], 'icon': Icons.pending_actions, 'color': Color(0xFFFF9800)},
                {'title': 'Total Revenue', 'value': 'UGX ${_dashboardData['total_revenue']}', 'icon': Icons.attach_money, 'color': Color(0xFF8E2DE2)},
                {'title': 'Total Customers', 'value': _dashboardData['total_customers'], 'icon': Icons.people, 'color': Color(0xFFB27AFF)},
              ][index];
              return Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: stats['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(stats['icon'], color: stats['color'], size: 20)),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(stats['title'], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    SizedBox(height: 4),
                    Text(stats['value'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23))),
                  ]),
                ]),
              );
            },
          ),
        
        SizedBox(height: 24),
        
        // Recent Orders
        Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () => setState(() => _selectedIndex = 2), child: Text('View All', style: TextStyle(color: Color(0xFF8E2DE2)))),
            ]),
            ...(_dashboardData['recent_orders'] as List).map((order) => Container(
              margin: EdgeInsets.only(bottom: 8), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFFF8F9FF), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Container(width: 35, height: 35, decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.check_circle, color: Colors.green, size: 18)),
                SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(order['id'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(order['customer'], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ])),
                Text('UGX ${order['amount']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF8E2DE2))),
              ]),
            )),
          ]),
        ),
        
        SizedBox(height: 16),
        
        // Top Products
        Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Top Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ...(_dashboardData['top_products'] as List).map((product) => Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: Text(product['name'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                  Text('UGX ${product['revenue']}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF8E2DE2))),
                ]),
                SizedBox(height: 4),
                LinearProgressIndicator(value: product['sales'] / 50, backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation(Color(0xFF8E2DE2))),
                Text('${product['growth']} growth', style: TextStyle(fontSize: 9, color: Colors.green)),
              ]),
            )),
          ]),
        ),
      ],
    );
  }
}