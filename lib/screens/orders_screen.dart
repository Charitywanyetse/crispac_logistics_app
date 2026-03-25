import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for HapticFeedback
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _statuses = ['Pending', 'Shipped', 'Delivered'];
  bool _isLoading = true;

  // Mock orders per status (in real app, fetch from API)
  Map<String, List<Map<String, dynamic>>> _orders = {
    'Pending': [],
    'Shipped': [],
    'Delivered': [],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
    _fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Simulate fetching orders from backend
  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    // Mock data (replace with actual API call)
    final allOrders = [
      {'id': 1000, 'status': 'Pending', 'date': DateTime.now().subtract(Duration(days: 2))},
      {'id': 1001, 'status': 'Pending', 'date': DateTime.now().subtract(Duration(days: 1))},
      {'id': 1002, 'status': 'Shipped', 'date': DateTime.now().subtract(Duration(days: 3))},
      {'id': 1003, 'status': 'Delivered', 'date': DateTime.now().subtract(Duration(days: 5))},
      {'id': 1004, 'status': 'Pending', 'date': DateTime.now().subtract(Duration(hours: 5))},
      {'id': 1005, 'status': 'Shipped', 'date': DateTime.now().subtract(Duration(days: 1))},
    ];
    // Group by status
    Map<String, List<Map<String, dynamic>>> grouped = {
      'Pending': [],
      'Shipped': [],
      'Delivered': [],
    };
    for (var order in allOrders) {
      grouped[order['status']]!.add(order);
    }
    setState(() {
      _orders = grouped;
      _isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Shipped':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF915BEE), // your primary purple
        bottom: TabBar(
          controller: _tabController,
          tabs: _statuses.map((status) => Tab(text: status)).toList(),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: _statuses.map((status) {
                final orders = _orders[status] ?? [];
                return RefreshIndicator(
                  onRefresh: _fetchOrders,
                  child: orders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                              SizedBox(height: 16),
                              Text(
                                'No $status orders',
                                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getStatusColor(status).withOpacity(0.1),
                                  child: Icon(Icons.local_shipping, color: _getStatusColor(status)),
                                ),
                                title: Text(
                                  'Order #${order['id']}',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                                    SizedBox(width: 4),
                                    Text(
                                      _formatDate(order['date']),
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(status).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: _getStatusColor(status),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                                  ],
                                ),
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OrderDetailsScreen(
                                        orderId: order['id'],
                                        orderStatus: status,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                );
              }).toList(),
            ),
    );
  }
}