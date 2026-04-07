import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _autoBackup = true;
  String _language = 'English';
  String _currency = 'UGX';
  String _timezone = 'Africa/Kampala';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF915BEE),
      ),
      body: ListView(
        children: [
          // Profile Settings
          _buildSection('Profile Settings'),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF915BEE).withOpacity(0.1),
                      child: Icon(Icons.person, color: Color(0xFF915BEE)),
                    ),
                    title: Text('Admin User'),
                    subtitle: Text('admin@crispac.com'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editProfile(),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Change Password'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => _changePassword(),
                  ),
                ],
              ),
            ),
          ),

          // Notification Settings
          _buildSection('Notifications'),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Email Notifications'),
                  subtitle: Text('Receive email updates about orders and support'),
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                Divider(),
                SwitchListTile(
                  title: Text('Push Notifications'),
                  subtitle: Text('Receive push notifications on your device'),
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // App Preferences
          _buildSection('App Preferences'),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Dark Mode'),
                  subtitle: Text('Switch to dark theme'),
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('Language'),
                  subtitle: Text(_language),
                  trailing: DropdownButton<String>(
                    value: _language,
                    underline: SizedBox(),
                    items: ['English', 'French', 'Spanish'].map((lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _language = value!;
                      });
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Currency'),
                  subtitle: Text(_currency),
                  trailing: DropdownButton<String>(
                    value: _currency,
                    underline: SizedBox(),
                    items: ['UGX', 'USD', 'EUR', 'GBP'].map((curr) {
                      return DropdownMenuItem(value: curr, child: Text(curr));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _currency = value!;
                      });
                    },
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Time Zone'),
                  subtitle: Text(_timezone),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => _selectTimezone(),
                ),
              ],
            ),
          ),

          // Business Settings
          _buildSection('Business Settings'),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.store),
                  title: Text('Business Information'),
                  subtitle: Text('Update your business details'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => _editBusinessInfo(),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.local_shipping),
                  title: Text('Shipping Settings'),
                  subtitle: Text('Configure shipping options'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => _shippingSettings(),
                ),
                Divider(),
                SwitchListTile(
                  title: Text('Auto Backup'),
                  subtitle: Text('Automatically backup data daily'),
                  value: _autoBackup,
                  onChanged: (value) {
                    setState(() {
                      _autoBackup = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // Data Management
          _buildSection('Data Management'),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.backup),
                  title: Text('Backup Data'),
                  subtitle: Text('Export all business data'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => _backupData(),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.restore),
                  title: Text('Restore Data'),
                  subtitle: Text('Import backed up data'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => _restoreData(),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.delete_sweep, color: Colors.red),
                  title: Text('Clear Cache', style: TextStyle(color: Colors.red)),
                  subtitle: Text('Clear temporary files and cache'),
                  trailing: Icon(Icons.chevron_right, color: Colors.red),
                  onTap: () => _clearCache(),
                ),
              ],
            ),
          ),

          // Danger Zone
          _buildSection('Danger Zone', color: Colors.red),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red),
              title: Text('Delete Account', style: TextStyle(color: Colors.red)),
              subtitle: Text('Permanently delete your account and all data'),
              trailing: Icon(Icons.chevron_right, color: Colors.red),
              onTap: () => _deleteAccount(),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(String title, {Color color = Colors.black87}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: 'Admin User'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: TextEditingController(text: 'admin@crispac.com'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password'),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _selectTimezone() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Select Timezone'),
        content: DropdownButton<String>(
          value: _timezone,
          items: ['Africa/Kampala', 'Africa/Nairobi', 'UTC', 'America/New_York'].map((tz) {
            return DropdownMenuItem(value: tz, child: Text(tz));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _timezone = value!;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _editBusinessInfo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Business Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Business Name'),
              controller: TextEditingController(text: 'Crispac Tailoring'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Phone'),
              controller: TextEditingController(text: '+256 123 456 789'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: TextEditingController(text: 'info@crispac.com'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Address'),
              controller: TextEditingController(text: 'Kampala, Uganda'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _shippingSettings() {
    // Implement shipping settings dialog
  }

  void _backupData() {
    // Implement backup functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Backup initiated...')),
    );
  }

  void _restoreData() {
    // Implement restore functionality
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Clear Cache'),
        content: Text('Are you sure you want to clear all cached data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Account', style: TextStyle(color: Colors.red)),
        content: Text(
          'This action is permanent and cannot be undone. All your data will be lost. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Account deletion requested')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}