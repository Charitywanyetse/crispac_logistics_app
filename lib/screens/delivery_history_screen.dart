import 'package:flutter/material.dart';

class DeliveryHistoryScreen extends StatelessWidget {
  // Mock data – replace with real API calls later
  final List<Map<String, dynamic>> _deliveries = [
    {
      'id': 'ORD-1001',
      'date': '2026-03-20',
      'status': 'Delivered',
      'items': 2,
      'total': 'UGX 83,000',
    },
    {
      'id': 'ORD-1002',
      'date': '2026-03-18',
      'status': 'Delivered',
      'items': 1,
      'total': 'UGX 38,000',
    },
    {
      'id': 'ORD-1003',
      'date': '2026-03-15',
      'status': 'Delivered',
      'items': 3,
      'total': 'UGX 145,000',
    },
    {
      'id': 'ORD-1004',
      'date': '2026-03-10',
      'status': 'Delivered',
      'items': 1,
      'total': 'UGX 45,000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery History'),
        backgroundColor: Color(0xFF915BEE),
      ),
      body: _deliveries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text('No deliveries yet', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _deliveries.length,
              itemBuilder: (context, index) {
                final delivery = _deliveries[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF915BEE).withOpacity(0.1),
                      child: Icon(Icons.local_shipping, color: Color(0xFF915BEE)),
                    ),
                    title: Text('Order #${delivery['id']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${delivery['date']}'),
                        Text('Items: ${delivery['items']} • Total: ${delivery['total']}'),
                      ],
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        delivery['status'],
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ),
                    onTap: () {
                      // Navigate to order details (could reuse OrderDetailsScreen)
                      // Navigator.push(...);
                    },
                  ),
                );
              },
            ),
    );
  }
}