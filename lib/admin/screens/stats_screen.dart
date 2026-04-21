import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'This Year'];
  
  final Map<String, Map<String, dynamic>> _statsData = {
    'today': {
      'orders': 12,
      'revenue': 245000,
      'customers': 8,
      'pending': 3,
      'completed': 9,
    },
    'week': {
      'orders': 78,
      'revenue': 1580000,
      'customers': 45,
      'pending': 12,
      'completed': 66,
    },
    'month': {
      'orders': 342,
      'revenue': 6840000,
      'customers': 189,
      'pending': 28,
      'completed': 314,
    },
    'year': {
      'orders': 4120,
      'revenue': 82400000,
      'customers': 2156,
      'pending': 145,
      'completed': 3975,
    },
  };
  
  final List<Map<String, String>> _recentActivities = [
    {'action': 'New order #TA-2456', 'customer': 'Maria Santos', 'amount': '₱45,000', 'time': '5 min ago'},
    {'action': 'Order completed #TA-2455', 'customer': 'John Reyes', 'amount': '₱78,500', 'time': '1 hour ago'},
    {'action': 'New customer registered', 'customer': 'Anna Garcia', 'amount': '', 'time': '3 hours ago'},
    {'action': 'Payment received', 'customer': 'Carlos Lopez', 'amount': '₱32,000', 'time': '5 hours ago'},
    {'action': 'Order shipped #TA-2454', 'customer': 'Maria Santos', 'amount': '₱92,000', 'time': 'Yesterday'},
  ];
  
  final List<Map<String, dynamic>> _monthlyRevenue = [
    {'month': 'Jan', 'revenue': 520000},
    {'month': 'Feb', 'revenue': 485000},
    {'month': 'Mar', 'revenue': 610000},
    {'month': 'Apr', 'revenue': 578000},
    {'month': 'May', 'revenue': 695000},
    {'month': 'Jun', 'revenue': 742000},
    {'month': 'Jul', 'revenue': 810000},
    {'month': 'Aug', 'revenue': 895000},
    {'month': 'Sep', 'revenue': 934000},
    {'month': 'Oct', 'revenue': 1020000},
    {'month': 'Nov', 'revenue': 1150000},
    {'month': 'Dec', 'revenue': 1280000},
  ];
  
  final List<Map<String, dynamic>> _topProducts = [
    {'name': 'Barong Tagalog', 'sales': 89, 'revenue': 445000, 'growth': '+15%'},
    {'name': 'Filipiniana Dress', 'sales': 76, 'revenue': 532000, 'growth': '+22%'},
    {'name': 'Terno Set', 'sales': 54, 'revenue': 378000, 'growth': '+8%'},
    {'name': 'Alampay Shawl', 'sales': 42, 'revenue': 126000, 'growth': '-5%'},
    {'name': 'Kimona Blouse', 'sales': 38, 'revenue': 152000, 'growth': '+12%'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentData = _statsData[_selectedPeriod.toLowerCase().replaceAll(' ', '_')]!;
    final maxRevenue = 1400000.0;
    
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text('Statistics & Analytics'),
        backgroundColor: Color(0xFF915BEE),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButton<String>(
              value: _selectedPeriod,
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Color(0xFF915BEE),
              style: TextStyle(color: Colors.white),
              items: _periods.map((String period) {
                return DropdownMenuItem<String>(
                  value: period,
                  child: Text(period),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedPeriod = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards Row
            Row(
              children: [
                _buildStatCard('Total Orders', currentData['orders'].toString(), Icons.shopping_cart, Color(0xFF6B48FF)),
                SizedBox(width: 12),
                _buildStatCard('Revenue', '₱${((currentData['revenue'] as int) ~/ 1000).toString()}K', Icons.attach_money, Color(0xFF915BEE)),
                SizedBox(width: 12),
                _buildStatCard('Customers', currentData['customers'].toString(), Icons.people, Color(0xFFB27AFF)),
                SizedBox(width: 12),
                _buildStatCard('Pending', currentData['pending'].toString(), Icons.pending_actions, Color(0xFFFF9800)),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Revenue Chart
            Container(
              padding: EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Revenue Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23))),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFF915BEE).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: Color(0xFF915BEE), shape: BoxShape.circle)),
                            SizedBox(width: 4),
                            Text('Revenue', style: TextStyle(fontSize: 10, color: Color(0xFF915BEE))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: ['1.4M', '1.0M', '600K', '200K', '0']
                              .map((label) => Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])))
                              .toList(),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _monthlyRevenue.length,
                            itemBuilder: (context, index) {
                              final data = _monthlyRevenue[index];
                              final revenue = data['revenue'] as int;
                              final height = (revenue / maxRevenue) * 160;
                              return Container(
                                width: 36,
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: height,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF915BEE),
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Transform.rotate(
                                      angle: -0.5,
                                      child: Text(
                                        data['month'] as String,
                                        style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem('Total Revenue', '₱${_formatNumber(_getTotalRevenue())}', '+23%'),
                        Container(width: 1, height: 30, color: Colors.grey[300]),
                        _buildSummaryItem('Avg Monthly', '₱${(_getTotalRevenue() ~/ 12 ~/ 1000).toString()}K', '+15%'),
                        Container(width: 1, height: 30, color: Colors.grey[300]),
                        _buildSummaryItem('Best Month', 'Dec', '₱1.28M'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Top Products and Recent Activities Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Top Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23))),
                        SizedBox(height: 16),
                        ..._topProducts.take(4).map((product) => Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product['name'] as String,
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                  '₱${((product['revenue'] as int) ~/ 1000).toString()}K',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF915BEE)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: (product['sales'] as int) / 100,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF915BEE)),
                                minHeight: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${product['sales']} sales', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                                  Row(
                                    children: [
                                      Icon(
                                        (product['growth'] as String).contains('+') ? Icons.trending_up : Icons.trending_down,
                                        size: 10,
                                        color: (product['growth'] as String).contains('+') ? Colors.green : Colors.red,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        product['growth'] as String,
                                        style: TextStyle(fontSize: 10, color: (product['growth'] as String).contains('+') ? Colors.green : Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recent Activities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23))),
                        SizedBox(height: 16),
                        ..._recentActivities.map((activity) => Container(
                          margin: EdgeInsets.only(bottom: 12),
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
                                  color: _getActivityColor(activity['action']!).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(_getActivityIcon(activity['action']!), color: _getActivityColor(activity['action']!), size: 18),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(activity['action']!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    Text(activity['customer']!, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (activity['amount']!.isNotEmpty)
                                    Text(activity['amount']!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF915BEE))),
                                  Text(activity['time']!, style: TextStyle(fontSize: 9, color: Colors.grey[500])),
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23))),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryItem(String label, String value, String change) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1C23))),
        Text(change, style: TextStyle(fontSize: 9, color: Colors.green)),
      ],
    );
  }
  
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
  
  int _getTotalRevenue() {
    int total = 0;
    for (var item in _monthlyRevenue) {
      total += item['revenue'] as int;
    }
    return total;
  }
  
  String _formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
  
  Color _getActivityColor(String action) {
    if (action.contains('completed')) return Colors.green;
    if (action.contains('shipped')) return Colors.blue;
    if (action.contains('pending') || action.contains('new')) return Colors.orange;
    if (action.contains('payment')) return Color(0xFF915BEE);
    return Colors.grey;
  }
  
  IconData _getActivityIcon(String action) {
    if (action.contains('completed')) return Icons.check_circle;
    if (action.contains('shipped')) return Icons.local_shipping;
    if (action.contains('pending')) return Icons.pending;
    if (action.contains('payment')) return Icons.payment;
    if (action.contains('registered')) return Icons.person_add;
    return Icons.notifications;
  }
}