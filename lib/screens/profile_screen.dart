import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/delivery_history_screen.dart';
import 'screens/support_contact_screen.dart';
import 'screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User information
  String _userName = 'Account name testing';
  String _userEmail = 'account@example.com';
  String _addressLine1 = '123 Main Street';
  String _addressLine2 = 'Apt 4B';
  String _city = 'Kampala';
  String _state = 'Central Region';
  String _zipCode = '256001';
  String _phoneNumber = '+256 700 123456';
  
  // Account settings
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _twoFactorAuth = false;
  
  // API Keys (mock data)
  String _apiKey = 'pk_live_abc123xyz789';
  String _clientId = 'client_12345';
  String _clientSecret = 'secret_67890';
  
  // Stats
  int _totalDeliveries = 24;
  double _rating = 4.8;
  int _onTimePercentage = 98;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B48FF),
              Color(0xFF915BEE),
              Color(0xFFB27AFF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      SizedBox(height: 16),
                      
                      // Title
                      Text(
                        'Create updates',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Manage your account and preferences',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile Content
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Cards Row
                        Row(
                          children: [
                            _buildStatCard('Deliveries', _totalDeliveries.toString(), Icons.local_shipping_outlined),
                            SizedBox(width: 12),
                            _buildStatCard('Rating', _rating.toString(), Icons.star_outline, suffix: ' ★'),
                            SizedBox(width: 12),
                            _buildStatCard('On Time', '$_onTimePercentage%', Icons.timer_outlined),
                          ],
                        ),
                        SizedBox(height: 24),

                        // Account Information Section
                        _buildSectionTitle(Icons.account_circle_outlined, "Account Information"),
                        SizedBox(height: 12),
                        _buildInfoCard([
                          _InfoItem("Account", _userName, Icons.person_outline),
                          _InfoItem("API keys", _apiKey, Icons.vpn_key_outlined, isSensitive: true),
                          _InfoItem("user-agent/agent users", "Mozilla/5.0...", Icons.devices_outlined),
                          _InfoItem("request headers", "Authorization: Bearer...", Icons.http_outlined),
                          _InfoItem("client_id", _clientId, Icons.badge_outlined),
                          _InfoItem("client_secret", _clientSecret, Icons.lock_outlined, isSensitive: true),
                        ]),

                        SizedBox(height: 24),

                        // Addresses Section
                        _buildSectionTitle(Icons.location_on_outlined, "Addresses"),
                        SizedBox(height: 12),
                        _buildInfoCard([
                          _InfoItem("Home address", "", Icons.home_outlined),
                          _InfoItem("Address line 1", _addressLine1, Icons.add_location_outlined),
                          _InfoItem("Address line 2", _addressLine2, Icons.add_location_outlined),
                          _InfoItem("City", _city, Icons.location_city_outlined),
                          _InfoItem("State", _state, Icons.map_outlined),
                          _InfoItem("Zip code", _zipCode, Icons.markunread_mailbox_outlined),
                        ]),

                        SizedBox(height: 24),

                        // Notifications Section
                        _buildSectionTitle(Icons.notifications_outlined, "Notifications"),
                        SizedBox(height: 12),
                        _buildSettingsCard([
                          _SettingsItem(
                            "User login",
                            Icons.login_outlined,
                            Switch(
                              value: _emailNotifications,
                              onChanged: (value) {
                                setState(() {
                                  _emailNotifications = value;
                                });
                              },
                              activeColor: Color(0xFF915BEE),
                            ),
                          ),
                          _SettingsItem(
                            "Email",
                            Icons.email_outlined,
                            Switch(
                              value: _emailNotifications,
                              onChanged: (value) {
                                setState(() {
                                  _emailNotifications = value;
                                });
                              },
                              activeColor: Color(0xFF915BEE),
                            ),
                          ),
                          _SettingsItem(
                            "Password",
                            Icons.lock_outlined,
                            Switch(
                              value: _pushNotifications,
                              onChanged: (value) {
                                setState(() {
                                  _pushNotifications = value;
                                });
                              },
                              activeColor: Color(0xFF915BEE),
                            ),
                          ),
                        ]),

                        SizedBox(height: 24),

                        // Account Actions Section
                        _buildSectionTitle(Icons.settings_applications_outlined, "Account Actions"),
                        SizedBox(height: 12),
                        _buildActionCard([
                          _ActionItem(
                            "Open account on app",
                            Icons.open_in_browser_outlined,
                            () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Opening account settings...'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                          _ActionItem(
                            "Security settings",
                            Icons.security_outlined,
                            () {
                              _showSecurityDialog();
                            },
                          ),
                        ]),

                        SizedBox(height: 24),

                        // Log Out Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _logout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, {String suffix = ''}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xFFF8F9FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Color(0xFF915BEE)),
            SizedBox(height: 8),
            Text(
              value + suffix,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF915BEE).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Color(0xFF915BEE), size: 20),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<_InfoItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.icon, size: 20, color: Color(0xFF915BEE)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.value.isEmpty ? 'Not set' : item.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: item.isSensitive ? Colors.grey[600] : Colors.black87,
                          fontFamily: item.isSensitive ? 'monospace' : null,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!item.value.isEmpty)
                  IconButton(
                    icon: Icon(Icons.copy, size: 18, color: Colors.grey[400]),
                    onPressed: () {
                      // Copy to clipboard
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.label} copied to clipboard'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsCard(List<_SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(item.icon, size: 20, color: Color(0xFF915BEE)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
                item.control,
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionCard(List<_ActionItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: items.map((item) {
          return ListTile(
            leading: Icon(item.icon, color: Color(0xFF915BEE)),
            title: Text(
              item.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
            onTap: item.onTap,
          );
        }).toList(),
      ),
    );
  }

  void _showSecurityDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Security Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text('Two-Factor Authentication'),
              subtitle: Text('Add an extra layer of security'),
              value: _twoFactorAuth,
              onChanged: (value) {
                setState(() {
                  _twoFactorAuth = value;
                });
                Navigator.pop(context);
              },
              activeColor: Color(0xFF915BEE),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}

class _InfoItem {
  final String label;
  final String value;
  final IconData icon;
  final bool isSensitive;
  
  _InfoItem(this.label, this.value, this.icon, {this.isSensitive = false});
}

class _SettingsItem {
  final String label;
  final IconData icon;
  final Widget control;
  
  _SettingsItem(this.label, this.icon, this.control);
}

class _ActionItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  
  _ActionItem(this.label, this.icon, this.onTap);
}