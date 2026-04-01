import 'package:flutter/material.dart';

class OrdersManagementScreen extends StatefulWidget {
  @override
  _OrdersManagementScreenState createState() => _OrdersManagementScreenState();
}

class _OrdersManagementScreenState extends State<OrdersManagementScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['All Orders', 'Pending', 'Processing', 'Completed', 'Cancelled'];

  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-1001',
      'customer': 'John Doe',
      'items': 2,
      'total': 90000,
      'status': 'Pending',
      'date': '2024-03-25',
      'payment': 'Pending',
    },
    {
      'id': 'ORD-1002',
      'customer': 'Jane Smith',
      'items': 1,
      'total': 38000,
      'status': 'Processing',
      'date': '2024-03-24',
      'payment': 'Paid',
    },
    {
      'id': 'ORD-1003',
      'customer': 'Mike Johnson',
      'items': 3,
      'total': 145000,
      'status': 'Completed',
      'date': '2024-03-23',
      'payment': 'Paid',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Orders Management'),
        backgroundColor: Color(0xFF915BEE),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              onTap: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              indicatorColor: Color(0xFF915BEE),
              labelColor: Color(0xFF915BEE),
              unselectedLabelColor: Colors.grey,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(order['status']).withOpacity(0.1),
                      child: Icon(Icons.shopping_bag, color: _getStatusColor(order['status'])),
                    ),
                    title: Text(
                      'Order #${order['id']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${order['customer']} • ${order['date']}'),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order['status'],
                        style: TextStyle(
                          color: _getStatusColor(order['status']),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('${order['items']} items'),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  'UGX ${order['total']}',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF915BEE)),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Payment:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getPaymentColor(order['payment']).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    order['payment'],
                                    style: TextStyle(
                                      color: _getPaymentColor(order['payment']),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _updateOrderStatus(order['id'], 'Processing');