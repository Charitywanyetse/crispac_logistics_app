import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<String> notifications = [
    'Your order #123 has been shipped',
    'Your delivery is arriving today',
    'Order #122 successfully delivered',
    'New promo: 10% off on next order',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications, color: Colors.deepPurple),
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}
