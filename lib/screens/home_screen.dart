import 'package:flutter/material.dart';
import 'products_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define purple theme colors
    final primaryColor = Colors.deepPurple;
    final lightPurple = Colors.deepPurple.shade100;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👋 Greeting
              Text(
                'Hi Charity 👋',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track and manage your deliveries',
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),

              // ➕ Create Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to Create Order Screen
                  },
                  icon: Icon(Icons.add),
                  label: Text('Create Order', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 📊 Quick Stats Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatsCard('Pending Orders', 5, lightPurple, primaryColor),
                  _buildStatsCard('Delivered Orders', 12, lightPurple, primaryColor),
                ],
              ),
              const SizedBox(height: 20),

              // 📝 Recent Orders List
              Text(
                'Recent Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: 5, // Example recent orders
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.local_shipping, color: primaryColor),
                        title: Text('Order #12345'),
                        subtitle: Text('Status: Pending', style: TextStyle(color: primaryColor)),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                        onTap: () {
                          // TODO: Navigate to Order Details
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: Build purple-themed stats card
  Widget _buildStatsCard(String title, int count, Color bgColor, Color textColor) {
    return Container(
      width: (200),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
