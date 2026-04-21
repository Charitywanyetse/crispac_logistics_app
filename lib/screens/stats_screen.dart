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
    'today': {'orders': 12, 'revenue': 245000, 'customers': 8, 'products': 156},
    'week': {'orders': 78, 'revenue': 1580000, 'customers': 45, 'products': 156},
    'month': {'orders': 342, 'revenue': 6840000, 'customers': 189, 'products': 156},
    'year': {'orders': 4120, 'revenue': 82400000, 'customers': 2156, 'products': 156},
  };
  
  final List<Map<String, dynamic>> _recentActivities = [
    {'action': 'New order #TA-2456', 'customer': 'Maria Santos', 'amount': 45000, 'time': '5 min ago', 'status': 'pending'},
    {'action': 'Order completed #TA-2455', 'customer': 'John Reyes', 'amount': 78500, 'time': '1 hour ago', 'status': 'completed'},
    {'action': 'New customer registered', 'customer': 'Anna Garcia', 'amount': 0, 'time': '3 hours ago', 'status': 'new'},
  ];
  
  final List<Map<String, dynamic>> _monthlyRevenue = [
    {'month': 'Jan', 'revenue': 520000, 'orders': 28},
    {'month': 'Feb', 'revenue': 485000, 'orders': 24},
    {'month': 'Mar', 'revenue': 610000, 'orders': 31},
    {'month': 'Apr', 'revenue': 578000, 'orders': 29},
    {'month': 'May', 'revenue': 695000, 'orders': 36},
    {'month': 'Jun', 'revenue': 742000, 'orders': 38},
  ];
  
  final List<Map<String, dynamic>> _topProducts = [
    {'name': 'Barong Tagalog', 'sales': 89, 'revenue': 445000, 'growth': '+15%'},
    {'name': 'Filipiniana Dress', 'sales': 76, 'revenue': 532000, 'growth': '+22%'},
    {'name': 'Terno Set', 'sales': 54, 'revenue': 378000, 'growth': '+8%'},
  ];

  @override
  Widget build(BuildContext context) {
    final currentData = _statsData[_selectedPeriod.toLowerCase().replaceAll(' ', '_')]!;
    
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
                setState(() {
                  _selectedPeriod = newValue!;
                });
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
            // Stats Cards
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final List<Map<String, dynamic>> stats = [
                  {'title': 'Total Orders', 'value': currentData['orders'], 'icon': Icons.shopping_cart, 'color': Color(0xFF6B48FF)},
                  {'title': 'Revenue', 'value': '₱${(currentData['revenue'] / 1000).toStringAsFixed(0)}K', 'icon': Icons.attach_money, 'color': Color(0xFF915BEE)},
                  {'title': 'Customers', 'value': currentData['customers'], 'icon': Icons.people, 'color': Color(0xFFB27AFF)},
                  {'title': 'Products', 'value': currentData['products'], 'icon': Icons.inventory, 'color': Color(0xFF6B48FF)},
                ];
                final stat = stats[index];
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: (stat['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Icon(stat['icon'] as IconData, color: stat['color'] as Color, size: 22),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(stat['title'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                          SizedBox(height: 2),
                          Text(stat['value'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            
            SizedBox(height: 24),
            
            // Revenue Chart
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenue Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                          children: ['800K', '600K', '400K', '200K', '0'].map((label) => Text(label, style: TextStyle(fontSize: 10))).toList()),
                        SizedBox(width: 8),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _monthlyRevenue.length,
                            itemBuilder: (context, index) {
                              final data = _monthlyRevenue[index];
                              final height = (data['revenue'] / 800000) * 160;
                              return Container(
                                width: 40,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(width: 24, height: height, 
                                      decoration: BoxDecoration(color: Color(0xFF915BEE), borderRadius: BorderRadius.vertical(top: Radius.circular(4)))),
                                    SizedBox(height: 8),
                                    Text(data['month'] as String, style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Top Products
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Top Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  ..._topProducts.map((product) => Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(child: Text(product['name'] as String, style: TextStyle(fontWeight: FontWeight.w500))),
                          Text('₱${(product['revenue'] / 1000).toStringAsFixed(0)}K', 
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF915BEE))),
                        ]),
                        SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: (product['sales'] as int) / 100, 
                          backgroundColor: Colors.grey[200], 
                          valueColor: AlwaysStoppedAnimation(Color(0xFF915BEE))),
                        Text(product['growth'] as String, style: TextStyle(fontSize: 11, color: Colors.green)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Recent Activities
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Activities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  ..._recentActivities.map((activity) => Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Color(0xFFF8F9FF), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Container(width: 40, height: 40, 
                          decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.check_circle, color: Colors.green)),
                        SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(activity['action'] as String, style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(activity['customer'] as String, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ])),
                        Text(activity['time'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}