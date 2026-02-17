import 'package:flutter/material.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.edit, color: Colors.deepPurple),
            title: Text('Edit Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.deepPurple),
            title: Text('Change Password'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.deepPurple),
            title: Text('Notifications'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.deepPurple),
            title: Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.deepPurple),
            title: Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
