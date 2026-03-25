import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'delivery_history_screen.dart';
import 'support_contact_screen.dart';
import 'settings_screen.dart'; // your existing settings screen

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock stats – replace with real data from backend later
  int _totalDeliveries = 24;
  double _rating = 4.8;
  int _onTimePercentage = 98;

  // User info – will come from backend
  String _userName = 'John Doe';
  String _userEmail = 'john@example.com';

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // remove token and all saved data
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF915BEE),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Stats Cards Row
          Row(
            children: [
              _buildStatCard('Deliveries', _totalDeliveries.toString(), Icons.local_shipping),
              SizedBox(width: 12),
              _buildStatCard('Rating', _rating.toString(), Icons.star, suffix: ' ★'),
              SizedBox(width: 12),
              _buildStatCard('On Time', '$_onTimePercentage%', Icons.timer),
            ],
          ),
          SizedBox(height: 24),

          // User Info Card (optional)
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF915BEE),
                    child: Icon(Icons.person, size: 32, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(_userEmail, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to edit profile screen (could be a dialog or new screen)
                      _showEditProfileDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Menu Items
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () => _showEditProfileDialog(),
          ),
          _buildMenuItem(
            icon: Icons.payment,
            title: 'Payment Methods',
            subtitle: 'Manage your payment options',
            onTap: () {
              // TODO: navigate to payment methods screen
            },
          ),
          _buildMenuItem(
            icon: Icons.history,
            title: 'Delivery History',
            subtitle: 'View all your past deliveries',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DeliveryHistoryScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.support_agent,
            title: 'Help & Support',
            subtitle: 'Get assistance with your deliveries',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SupportContactScreen()),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'App preferences, notifications, privacy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              );
            },
          ),
          Divider(height: 32),
          // Log Out Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Log Out', style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, {String suffix = ''}) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Color(0xFF915BEE)),
              SizedBox(height: 8),
              Text(
                value + suffix,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(label, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF915BEE)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _userName = nameController.text;
                _userEmail = emailController.text;
              });
              Navigator.pop(context);
              // TODO: send updated data to backend
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}