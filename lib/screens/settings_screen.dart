import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // for clipboard, haptics

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ---------- State variables ----------
  bool _isLoading = true;
  Map<String, dynamic> _userProfile = {};

  // Notifications preferences (defaults)
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _deliveryUpdates = true;
  bool _promotions = false;

  // App preferences
  bool _darkMode = false;
  String _language = 'English';
  bool _autoPlay = true;

  // Privacy
  bool _shareLocation = true;
  bool _showOnlineStatus = true;

  // ---------- Lifecycle ----------
  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _loadSettingsFromStorage();
  }

  // ---------- API & Storage ----------
  Future<void> _fetchUserProfile() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Not authenticated');

      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/user/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userProfile = data['data'] ?? data;
        });
      } else {
        _showSnackBar('Failed to load profile');
      }
    } catch (e) {
      _showSnackBar('Network error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfile(Map<String, dynamic> updatedData) async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Not authenticated');

      final response = await http.put(
        Uri.parse('http://localhost:8000/api/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userProfile = data['data'] ?? data;
        });
        _showSnackBar('Profile updated');
      } else {
        _showSnackBar('Failed to update profile');
      }
    } catch (e) {
      _showSnackBar('Network error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadSettingsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('pushNotifications') ?? true;
      _emailNotifications = prefs.getBool('emailNotifications') ?? true;
      _smsNotifications = prefs.getBool('smsNotifications') ?? false;
      _deliveryUpdates = prefs.getBool('deliveryUpdates') ?? true;
      _promotions = prefs.getBool('promotions') ?? false;
      _darkMode = prefs.getBool('darkMode') ?? false;
      _language = prefs.getString('language') ?? 'English';
      _autoPlay = prefs.getBool('autoPlay') ?? true;
      _shareLocation = prefs.getBool('shareLocation') ?? true;
      _showOnlineStatus = prefs.getBool('showOnlineStatus') ?? true;
    });
  }

  void _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    // Optionally sync with backend
  }

  // ---------- UI Helpers ----------
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  Future<void> _showEditDialog(String field, String currentValue) async {
    final controller = TextEditingController(text: currentValue);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: field),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result != currentValue) {
      _updateProfile({field.toLowerCase(): result});
    }
  }

  void _showChangePasswordDialog() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: confirmController,
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
          TextButton(
            onPressed: () async {
              if (newController.text != confirmController.text) {
                _showSnackBar('Passwords do not match');
                return;
              }
              await _changePassword(currentController.text, newController.text);
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword(String current, String newPassword) async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('http://localhost:8000/api/user/change-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'current_password': current,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Password changed successfully');
      } else {
        _showSnackBar('Failed to change password');
      }
    } catch (e) {
      _showSnackBar('Network error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure? This action is permanent.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('http://localhost:8000/api/user/delete'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Clear local data and navigate to login
        await prefs.clear();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        _showSnackBar('Failed to delete account');
      }
    } catch (e) {
      _showSnackBar('Network error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF915BEE),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchUserProfile,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                // Personal Information Section
                _buildSectionHeader('Personal Information'),
                _buildProfileTile(
                  icon: Icons.person,
                  title: 'Name',
                  value: _userProfile['name'] ?? 'Not set',
                  onTap: () => _showEditDialog('Name', _userProfile['name'] ?? ''),
                ),
                _buildProfileTile(
                  icon: Icons.email,
                  title: 'Email',
                  value: _userProfile['email'] ?? 'Not set',
                  onTap: () => _showEditDialog('Email', _userProfile['email'] ?? ''),
                ),
                _buildProfileTile(
                  icon: Icons.phone,
                  title: 'Phone',
                  value: _userProfile['phone'] ?? 'Not set',
                  onTap: () => _showEditDialog('Phone', _userProfile['phone'] ?? ''),
                ),
                _buildProfileTile(
                  icon: Icons.location_on,
                  title: 'Address',
                  value: _userProfile['address'] ?? 'Not set',
                  onTap: () => _showEditDialog('Address', _userProfile['address'] ?? ''),
                ),
                Divider(height: 24, thickness: 1),

                // Account Security
                _buildSectionHeader('Account Security'),
                ListTile(
                  leading: Icon(Icons.lock_outline, color: Colors.grey[700]),
                  title: Text('Change Password'),
                  subtitle: Text('Update your password'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: _showChangePasswordDialog,
                ),
                ListTile(
                  leading: Icon(Icons.security, color: Colors.grey[700]),
                  title: Text('Two-Factor Authentication'),
                  subtitle: Text('Enhanced account security'),
                  trailing: Switch(
                    value: false, // will be fetched from backend
                    onChanged: (v) {
                      // TODO: implement 2FA toggle
                    },
                  ),
                ),
                Divider(height: 24, thickness: 1),

                // Notifications
                _buildSectionHeader('Notifications'),
                _buildSwitchTile(
                  icon: Icons.notifications_active,
                  title: 'Push Notifications',
                  subtitle: 'Receive push notifications',
                  value: _pushNotifications,
                  onChanged: (v) {
                    setState(() => _pushNotifications = v);
                    _saveSetting('pushNotifications', v);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.email_outlined,
                  title: 'Email Notifications',
                  subtitle: 'Receive email updates',
                  value: _emailNotifications,
                  onChanged: (v) {
                    setState(() => _emailNotifications = v);
                    _saveSetting('emailNotifications', v);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.sms,
                  title: 'SMS Notifications',
                  subtitle: 'Receive text messages',
                  value: _smsNotifications,
                  onChanged: (v) {
                    setState(() => _smsNotifications = v);
                    _saveSetting('smsNotifications', v);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.local_shipping,
                  title: 'Delivery Updates',
                  subtitle: 'Get notifications about delivery status',
                  value: _deliveryUpdates,
                  onChanged: (v) {
                    setState(() => _deliveryUpdates = v);
                    _saveSetting('deliveryUpdates', v);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.local_offer,
                  title: 'Promotions & Offers',
                  subtitle: 'Receive special offers',
                  value: _promotions,
                  onChanged: (v) {
                    setState(() => _promotions = v);
                    _saveSetting('promotions', v);
                  },
                ),
                Divider(height: 24, thickness: 1),

                // App Preferences
                _buildSectionHeader('App Preferences'),
                _buildSwitchTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Switch to dark theme',
                  value: _darkMode,
                  onChanged: (v) {
                    setState(() => _darkMode = v);
                    _saveSetting('darkMode', v);
                    // TODO: implement theme change
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language, color: Colors.grey[700]),
                  title: Text('Language'),
                  subtitle: Text(_language),
                  trailing: DropdownButton<String>(
                    value: _language,
                    underline: SizedBox(),
                    items: ['English', 'French', 'Spanish']
                        .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                        .toList(),
                    onChanged: (lang) {
                      setState(() => _language = lang!);
                      _saveSetting('language', lang);
                    },
                  ),
                ),
                _buildSwitchTile(
                  icon: Icons.play_circle_outline,
                  title: 'Auto-play Videos',
                  subtitle: 'Automatically play videos',
                  value: _autoPlay,
                  onChanged: (v) {
                    setState(() => _autoPlay = v);
                    _saveSetting('autoPlay', v);
                  },
                ),
                Divider(height: 24, thickness: 1),

                // Privacy
                _buildSectionHeader('Privacy'),
                _buildSwitchTile(
                  icon: Icons.location_on,
                  title: 'Share Location',
                  subtitle: 'Allow location access',
                  value: _shareLocation,
                  onChanged: (v) {
                    setState(() => _shareLocation = v);
                    _saveSetting('shareLocation', v);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.visibility,
                  title: 'Show Online Status',
                  subtitle: 'Let others see when you\'re online',
                  value: _showOnlineStatus,
                  onChanged: (v) {
                    setState(() => _showOnlineStatus = v);
                    _saveSetting('showOnlineStatus', v);
                  },
                ),
                Divider(height: 24, thickness: 1),

                // About
                _buildSectionHeader('About'),
                _buildInfoTile('App Version', '1.0.0'),
                _buildInfoTile('Last Updated', 'March 1, 2026'),
                ListTile(
                  leading: Icon(Icons.privacy_tip, color: Colors.grey[700]),
                  title: Text('Privacy Policy'),
                  trailing: Icon(Icons.open_in_new),
                  onTap: () {
                    // open URL
                  },
                ),
                ListTile(
                  leading: Icon(Icons.description, color: Colors.grey[700]),
                  title: Text('Terms of Service'),
                  trailing: Icon(Icons.open_in_new),
                  onTap: () {
                    // open URL
                  },
                ),
                Divider(height: 24, thickness: 1),

                // Danger Zone
                _buildSectionHeader('Danger Zone', color: Colors.red),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: Colors.red),
                  title: Text('Delete Account', style: TextStyle(color: Colors.red)),
                  subtitle: Text('Permanently delete your account and data'),
                  trailing: Icon(Icons.chevron_right, color: Colors.red),
                  onTap: _deleteAccount,
                ),
                SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, {Color color = Colors.black87}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      subtitle: Text(value.isNotEmpty ? value : 'Not set'),
      trailing: Icon(Icons.edit),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      leading: Icon(Icons.info_outline, color: Colors.grey[700]),
      title: Text(title),
      trailing: Text(value, style: TextStyle(color: Colors.grey[600])),
    );
  }
}



// import 'package:flutter/material.dart';

// class SettingsScreen extends StatefulWidget {
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   // ===== USER DATA =====
//   String _userName = 'wanyetse charity';
//   String _userEmail = 'wanyetse.charity@email.com';
//   String _userPhone = '+256 (555) 123-4567';
//   String _userAddress = 'uganda,kampala, bukoto';
  
//   // ===== NOTIFICATION SETTINGS =====
//   bool _pushNotifications = true;
//   bool _emailNotifications = true;
//   bool _smsNotifications = false;
//   bool _deliveryUpdates = true;
//   bool _promoNotifications = false;
  
//   // ===== APP PREFERENCES =====
//   bool _darkMode = false;
//   String _selectedLanguage = 'English';
//   bool _autoPlay = true;
//   bool _saveData = false;
  
//   // ===== PRIVACY SETTINGS =====
//   bool _shareLocation = true;
//   bool _showOnlineStatus = true;
//   bool _twoFactorAuth = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text(
//           'Settings',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 22,
//           ),
//         ),
//         backgroundColor: Color.fromARGB(255, 169, 143, 247), // Your purple color
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: () => _saveAllSettings(context),
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           // ===== PROFILE SECTION (EDITABLE) =====
//           Container(
//             margin: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF9B7BFF), Color(0xFF7B5BFF)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0xFF9B7BFF).withOpacity(0.3),
//                   blurRadius: 10,
//                   offset: Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   // Profile Image (click to change)
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.white,
//                         child: Text(
//                           _userName[0].toUpperCase(),
//                           style: TextStyle(
//                             fontSize: 40,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF9B7BFF),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: GestureDetector(
//                           onTap: () => _showImageOptions(context),
//                           child: Container(
//                             padding: EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.camera_alt,
//                               size: 20,
//                               color: Color(0xFF9B7BFF),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
                  
//                   // Editable Name
//                   _buildEditableField(
//                     icon: Icons.person,
//                     value: _userName,
//                     label: 'Name',
//                     onTap: () => _showEditDialog(
//                       'Edit Name',
//                       _userName,
//                       (newValue) => setState(() => _userName = newValue),
//                     ),
//                   ),
//                   SizedBox(height: 8),
                  
//                   // Editable Email
//                   _buildEditableField(
//                     icon: Icons.email,
//                     value: _userEmail,
//                     label: 'Email',
//                     onTap: () => _showEditDialog(
//                       'Edit Email',
//                       _userEmail,
//                       (newValue) => setState(() => _userEmail = newValue),
//                     ),
//                   ),
//                   SizedBox(height: 8),
                  
//                   // Editable Phone
//                   _buildEditableField(
//                     icon: Icons.phone,
//                     value: _userPhone,
//                     label: 'Phone',
//                     onTap: () => _showEditDialog(
//                       'Edit Phone',
//                       _userPhone,
//                       (newValue) => setState(() => _userPhone = newValue),
//                     ),
//                   ),
//                   SizedBox(height: 8),
                  
//                   // Editable Address
//                   _buildEditableField(
//                     icon: Icons.location_on,
//                     value: _userAddress,
//                     label: 'Address',
//                     onTap: () => _showEditDialog(
//                       'Edit Address',
//                       _userAddress,
//                       (newValue) => setState(() => _userAddress = newValue),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // ===== ACCOUNT SECURITY =====
//           _buildSectionTitle('Account Security'),
          
//           _buildSettingsItem(
//             icon: Icons.lock_outline,
//             title: 'Change Password',
//             subtitle: 'Update your password',
//             onTap: () => _showChangePasswordDialog(context),
//           ),
          
//           _buildSwitchItem(
//             icon: Icons.fingerprint,
//             title: 'Two-Factor Authentication',
//             subtitle: 'Enhanced account security',
//             value: _twoFactorAuth,
//             onChanged: (value) => setState(() => _twoFactorAuth = value),
//           ),

//           // ===== NOTIFICATION PREFERENCES =====
//           _buildSectionTitle('Notifications'),
          
//           _buildSwitchItem(
//             icon: Icons.notifications_outlined,
//             title: 'Push Notifications',
//             subtitle: 'Receive push notifications',
//             value: _pushNotifications,
//             onChanged: (value) => setState(() => _pushNotifications = value),
//           ),
          
//           _buildSwitchItem(
//             icon: Icons.email_outlined,
//             title: 'Email Notifications',
//             subtitle: 'Receive email updates',
//             value: _emailNotifications,
//             onChanged: (value) => setState(() => _emailNotifications = value),
//             enabled: _pushNotifications,
//           ),
          
//           _buildSwitchItem(
//             icon: Icons.sms_outlined,
//             title: 'SMS Notifications',
//             subtitle: 'Receive text messages',
//             value: _smsNotifications,
//             onChanged: (value) => setState(() => _smsNotifications = value),
//             enabled: _pushNotifications,
//           ),
          
//           _buildSwitchItem(
//             icon: Icons.delivery_dining,
//             title: 'Delivery Updates',
//             subtitle: 'Get notified about delivery status',
//             value: _deliveryUpdates,
//             onChanged: (value) => setState(() => _deliveryUpdates = value),
//           ),
          
//           _buildSwitchItem(
//             icon: Icons.local_offer,
//             title: 'Promotions & Offers',
//             subtitle: 'Receive special offers',
//             value: _promoNotifications,
//             onChanged: (value) => setState(() => _promoNotifications = value),
//           ),

//           // ===== APP PREFERENCES =====
//           _buildSectionTitle('App Preferences'),
          
//           _buildSwitchItem(
//             icon: Icons.dark_mode,
//             title: 'Dark Mode',
//             subtitle: 'Switch to dark theme',
//             value: _darkMode,
//             onChanged: (value) => setState(() => _darkMode = value),
//           ),
          
//           _buildSettingsItem(
//             icon: Icons.language,
//             title: 'Language',
//             subtitle: _selectedLanguage,
//             onTap: () => _showLanguageDialog(context),
//           ),
          
//           _buildSwitchItem(
//             icon: Icons.play_circle_outline,
//             title: 'Auto-play Videos',
//             subtitle: 'Automatically play videos',
//             value: _autoPlay,
//             onChanged: (value) => setState(() => _autoPlay = value),
//           ),
          
//           _buildSwitchItem(
//             icon: Icons.data_usage,
//             title: 'Data Saver',
//             subtitle: 'Reduce data usage',
//             value: _saveData,
//             onChanged: (value) => setState(() => _saveData = value),
//           ),

//           // ===== PRIVACY =====
//           _buildSectionTitle('Privacy'),
          
//           _buildSwitchItem(
//             icon: Icons.location_on,
//             title: 'Share Location',
//             subtitle: 'Allow location access',
//             value: _shareLocation,
//             onChanged: (value) => setState(() => _shareLocation = value),
//           ),
          
//           _buildSwitchItem(
//             icon: Icons.visibility,
//             title: 'Show Online Status',
//             subtitle: 'Let others see when you\'re online',
//             value: _showOnlineStatus,
//             onChanged: (value) => setState(() => _showOnlineStatus = value),
//           ),

//           // ===== ABOUT =====
//           _buildSectionTitle('About'),
          
//           _buildAboutItem(
//             icon: Icons.info_outline,
//             title: 'App Version',
//             value: '1.0.0',
//           ),
          
//           _buildAboutItem(
//             icon: Icons.update,
//             title: 'Last Updated',
//             value: 'March 4, 2026',
//           ),
          
//           _buildSettingsItem(
//             icon: Icons.privacy_tip_outlined,
//             title: 'Privacy Policy',
//             subtitle: 'Read our privacy policy',
//             onTap: () => _showPrivacyPolicy(context),
//           ),
          
//           _buildSettingsItem(
//             icon: Icons.description_outlined,
//             title: 'Terms of Service',
//             subtitle: 'Read our terms',
//             onTap: () => _showTermsOfService(context),
//           ),

//           // ===== DANGER ZONE =====
//           _buildSectionTitle('Danger Zone', isDanger: true),
          
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.red.shade200),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               children: [
//                 ListTile(
//                   leading: Icon(Icons.delete_outline, color: Colors.red),
//                   title: Text('Delete Account', style: TextStyle(color: Colors.red)),
//                   subtitle: Text('Permanently delete your account and data'),
//                   onTap: () => _showDeleteAccountDialog(context),
//                 ),
//               ],
//             ),
//           ),

//           // ===== LOGOUT BUTTON =====
//           Container(
//             margin: EdgeInsets.all(16),
//             child: ElevatedButton(
//               onPressed: () => _showLogoutDialog(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Color(0xFF9B7BFF),
//                 elevation: 0,
//                 padding: EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   side: BorderSide(color: Color(0xFF9B7BFF).withOpacity(0.3)),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.logout, color: Color(0xFF9B7BFF)),
//                   SizedBox(width: 8),
//                   Text(
//                     'Log Out',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF9B7BFF),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   // ===== HELPER WIDGETS =====

//   Widget _buildEditableField({
//     required IconData icon,
//     required String value,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 18),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.white.withOpacity(0.7),
//                     ),
//                   ),
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.edit, color: Colors.white, size: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title, {bool isDanger = false}) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.bold,
//           color: isDanger ? Colors.red : Color(0xFF9B7BFF),
//           letterSpacing: 0.5,
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingsItem({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     required VoidCallback onTap,
//     bool showArrow = true,
//     Color? color,
//   }) {
//     return ListTile(
//       leading: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: (color ?? Color(0xFF9B7BFF)).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(icon, color: color ?? Color(0xFF9B7BFF), size: 22),
//       ),
//       title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
//       subtitle: subtitle != null 
//         ? Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600]))
//         : null,
//       trailing: showArrow 
//         ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])
//         : null,
//       onTap: onTap,
//     );
//   }

//   Widget _buildSwitchItem({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     required bool value,
//     required Function(bool) onChanged,
//     bool enabled = true,
//   }) {
//     return SwitchListTile(
//       secondary: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: (enabled ? Color(0xFF9B7BFF) : Colors.grey).withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           icon, 
//           color: enabled ? Color(0xFF9B7BFF) : Colors.grey,
//           size: 22,
//         ),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           color: enabled ? Colors.black : Colors.grey,
//         ),
//       ),
//       subtitle: subtitle != null 
//         ? Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 13,
//               color: enabled ? Colors.grey[600] : Colors.grey[400],
//             ),
//           )
//         : null,
//       value: value,
//       onChanged: enabled ? onChanged : null,
//       activeColor: Color(0xFF9B7BFF),
//     );
//   }

//   Widget _buildAboutItem({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return ListTile(
//       leading: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(icon, color: Colors.grey.shade700, size: 22),
//       ),
//       title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
//       trailing: Text(
//         value,
//         style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//       ),
//     );
//   }

//   // ===== DIALOGS =====

//   void _showEditDialog(String title, String currentValue, Function(String) onSave) {
//     TextEditingController controller = TextEditingController(text: currentValue);
    
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               hintText: 'Enter new value',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (controller.text.isNotEmpty) {
//                   onSave(controller.text);
//                   Navigator.pop(context);
//                   _showSnackBar(context, '$title updated successfully');
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF9B7BFF),
//               ),
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showChangePasswordDialog(BuildContext context) {
//     TextEditingController oldPass = TextEditingController();
//     TextEditingController newPass = TextEditingController();
//     TextEditingController confirmPass = TextEditingController();
    
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Change Password'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: oldPass,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Current Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 12),
//               TextField(
//                 controller: newPass,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'New Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 12),
//               TextField(
//                 controller: confirmPass,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (newPass.text == confirmPass.text) {
//                   Navigator.pop(context);
//                   _showSnackBar(context, 'Password changed successfully');
//                 } else {
//                   _showSnackBar(context, 'Passwords do not match', isError: true);
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF9B7BFF),
//               ),
//               child: Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showLanguageDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select Language'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildLanguageOption('English', _selectedLanguage == 'English'),
//               _buildLanguageOption('Spanish', _selectedLanguage == 'Spanish'),
//               _buildLanguageOption('French', _selectedLanguage == 'French'),
//               _buildLanguageOption('German', _selectedLanguage == 'German'),
//               _buildLanguageOption('Chinese', _selectedLanguage == 'Chinese'),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildLanguageOption(String language, bool isSelected) {
//     return ListTile(
//       title: Text(language),
//       leading: isSelected 
//         ? Icon(Icons.check_circle, color: Color(0xFF9B7BFF))
//         : Icon(Icons.radio_button_unchecked, color: Colors.grey),
//       onTap: () {
//         setState(() => _selectedLanguage = language);
//         Navigator.pop(context);
//         _showSnackBar(context, 'Language changed to $language');
//       },
//     );
//   }

//   void _showImageOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.photo_library, color: Color(0xFF9B7BFF)),
//                 title: Text('Choose from Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showSnackBar(context, 'Gallery opened');
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_camera, color: Color(0xFF9B7BFF)),
//                 title: Text('Take Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showSnackBar(context, 'Camera opened');
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.delete, color: Colors.red),
//                 title: Text('Remove Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showSnackBar(context, 'Photo removed');
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showPrivacyPolicy(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Privacy Policy'),
//           content: Container(
//             width: double.maxFinite,
//             child: Text(
//               'Your privacy is important to us. This privacy policy explains how we collect, use, and protect your personal information when you use our app.\n\n'
//               '1. Information We Collect\n'
//               '2. How We Use Your Information\n'
//               '3. Data Security\n'
//               '4. Your Rights\n'
//               '5. Contact Us',
//               style: TextStyle(height: 1.5),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showTermsOfService(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Terms of Service'),
//           content: Container(
//             width: double.maxFinite,
//             child: Text(
//               'By using this app, you agree to these terms. Please read them carefully.\n\n'
//               '1. Acceptance of Terms\n'
//               '2. User Responsibilities\n'
//               '3. Account Termination\n'
//               '4. Limitation of Liability\n'
//               '5. Changes to Terms',
//               style: TextStyle(height: 1.5),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteAccountDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Account', style: TextStyle(color: Colors.red)),
//           content: Text(
//             'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _showSnackBar(context, 'Account deleted', isError: true);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//               child: Text('Delete Permanently'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Log Out'),
//           content: Text('Are you sure you want to log out?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _performLogout(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//               child: Text('Log Out'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _saveAllSettings(BuildContext context) {
//     // Here you would save all settings to backend/shared preferences
//     _showSnackBar(context, 'All settings saved successfully');
//   }

//   void _performLogout(BuildContext context) {
//     _showSnackBar(context, 'Logged out successfully');
//     // Navigate to login screen (you'll implement this)
//   }

//   void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Color(0xFF9B7BFF),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }