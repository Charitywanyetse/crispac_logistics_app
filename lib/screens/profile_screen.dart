import 'package:flutter/material.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // ===== PROFILE HEADER =====
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // Profile Picture with camera icon overlay
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with user's image
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe', // Replace with actual user name
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'john.doe@email.com', // Replace with actual email
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '+1 (555) 123-4567', // Replace with actual phone
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Divider(thickness: 8, color: Colors.grey[100]),
          
          // ===== STATS CARDS =====
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.inventory,
                    value: '24',
                    label: 'Deliveries',
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.star,
                    value: '4.8',
                    label: 'Rating',
                    color: Colors.amber,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.timer,
                    value: '98%',
                    label: 'On Time',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          
          Divider(thickness: 8, color: Colors.grey[100]),
          
          // ===== PROFILE MENU ITEMS =====
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () {
              // Navigate to edit profile screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
          ),
          
          // _buildMenuItem(
          //   icon: Icons.location_on_outline,
          //   title: 'Saved Addresses',
          //   subtitle: 'Home, Work, and other addresses',
          //   onTap: () {
          //     // Navigate to addresses screen
          //     //  Navigator.push(context, MaterialPageRoute(builder: (context) => AddressesScreen()));
          //   },
          // ),
          
          _buildMenuItem(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            subtitle: 'Manage your payment options',
            onTap: () {
              // Navigate to payment methods
              // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentMethodsScreen()));
            },
          ),
          
          _buildMenuItem(
            icon: Icons.history,
            title: 'Delivery History',
            subtitle: 'View all your past deliveries',
            onTap: () {
              // Navigate to delivery history
              // Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryHistoryScreen()));
            },
          ),
          
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get assistance with your deliveries',
            onTap: () {
              // Navigate to help center
              // Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportScreen()));
            },
          ),
          
          Divider(thickness: 8, color: Colors.grey[100]),
          
          // ===== SETTINGS BUTTON (Links to Settings Screen) =====
          _buildMenuItem(
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'App preferences, notifications, privacy',
            showArrow: true,
            isSettings: true,
            onTap: () {
              // 👈 THIS OPENS THE SETTINGS SCREEN
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          
          // ===== LOGOUT BUTTON =====
          Container(
            margin: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Log Out', style: TextStyle(fontSize: 16)),
            ),
          ),
          
          SizedBox(height: 20),
        ],
      ),
    );
  }
  
  Widget _buildStatCard({required IconData icon, required String value, required String label, required Color color}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
    bool isSettings = false,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSettings ? Colors.blue.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon, 
          color: isSettings ? Colors.blue : Colors.grey.shade700,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSettings ? FontWeight.w600 : FontWeight.normal,
          color: isSettings ? Colors.blue : Colors.black,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12)) : null,
      trailing: showArrow ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}

// Make sure to import SettingsScreen at the top
// import 'settings_screen.dart';