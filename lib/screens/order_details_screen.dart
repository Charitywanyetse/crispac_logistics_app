import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int orderId;

  OrderDetailsScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #$orderId'),
        backgroundColor: const Color.fromARGB(255, 169, 135, 226),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Products:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Example product list
            ListTile(
              title: Text('Product A'),
              subtitle: Text('Quantity: 2'),
            ),
            ListTile(
              title: Text('Product B'),
              subtitle: Text('Quantity: 1'),
            ),
            Divider(),
            Text('Delivery Address:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('123 Main Street, Mbale City', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Status: Pending', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Estimated Delivery: 20 Feb 2026', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
