import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Crispac Logistics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Version: 1.0.0', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              'Crispac Logistics is your go-to app for managing and tracking all your deliveries efficiently. Stay updated and track your packages in real-time.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text('Contact: support@crispaclogistics.com', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
