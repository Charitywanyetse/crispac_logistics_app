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
                  on