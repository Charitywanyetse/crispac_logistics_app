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
        backgroundColor: const Color.fromARGB(255, 169, 122, 250),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications, color: const Color.fromARGB(255, 167, 121, 247)),
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}
