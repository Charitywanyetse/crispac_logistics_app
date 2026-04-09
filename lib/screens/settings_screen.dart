import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification Settings
  bool _pushNotification = true;
  bool _emailUpdates = true;
  bool _promotionalOffers = false;
  
  // Security & Privacy
  bool _biometricLogin = false;
  
  // App Preferences
  String _selectedLanguage = 'English (US)';
  bool _darkMode = false;
  
  // App Version
  String _appVersion = 'v1.0.1 (Beta)';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotification = prefs.getBool('push_notification') ?? true;
      _emailUpdates = prefs.getBool('email_updates') ?? true;
      _promotionalOffers = prefs.getBool('promotional_offers') ?? false;
      _biometricLogin = prefs.getBool('biometric_login') ?? false;
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'English (US)';
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveStringSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English (US)'),
              trailing: _selectedLanguage == 'English (US)' 
                  ? Icon(Icons.check, color: Color(0xFF8E2DE2)) 
                  : null,
              onTap: () {
                setState(() {
                  _selectedLanguage = 'English (US)';
                  _saveStringSetting('language', 'English (US)');
                });
                Navigator.pop(context);
                _showSnackBar('Language updated to English (US)');
              },
            ),
            ListTile(
              title: Text('Spanish (ES)'),
              trailing: _selectedLanguage == 'Spanish (ES)' 
                  ? Icon(Icons.check, color: Color(0xFF8E2DE2)) 
                  : null,
              onTap: () {
                setState(() {
                  _selectedLanguage = 'Spanish (ES)';
                  _saveStringSetting('language', 'Spanish (ES)');
                });
                Navigator.pop(context);
                _showSnackBar('Language updated to Spanish (ES)');
              },
            ),
            ListTile(
              title: Text('French (FR)'),
              trailing: _selectedLanguage == 'French (FR)' 
                  ? Icon(Icons.check, color: Color(0xFF8E2DE2)) 
                  : null,
              onTap: () {
                setState(() {
                  _selectedLanguage = 'French (FR)';
                  _saveStringSetting('language', 'French (FR)');
                });
                Navigator.pop(context);
                _showSnackBar('Language updated to French (FR)');
              },
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

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              _showSnackBar('Cache cleared successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(0xFF8E2DE2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ACCOUNT SETTINGS Section
            _buildSectionHeader('ACCOUNT SETTINGS'),
            SizedBox(height: 8),
            
            _buildProfileTile(
              title: 'Manage Profile',
              subtitle: 'Upgrade to a new account',
              icon: Icons.person_outline,
              onTap: () {
                _showSnackBar('Navigate to Profile Management');
              },
            ),
            
            _buildProfileTile(
              title: 'Change Email',
              subtitle: 'Edit, send or upgrade your email',
              icon: Icons.email_outlined,
              onTap: () {
                _showSnackBar('Navigate to Email Change');
              },
            ),
            
            _buildProfileTile(
              title: 'Change Password',
              subtitle: 'Last changed 13 remaining days',
              icon: Icons.lock_outline,
              onTap: () {
                _showSnackBar('Navigate to Password Change');
              },
            ),
            
            SizedBox(height: 24),
            
            // NOTIFICATIONS Section
            _buildSectionHeader('NOTIFICATIONS'),
            SizedBox(height: 8),
            
            _buildSwitchTile(
              title: 'Push Notification',
              value: _pushNotification,
              onChanged: (value) {
                setState(() {
                  _pushNotification = value;
                  _saveSetting('push_notification', value);
                });
              },
            ),
            
            _buildSwitchTile(
              title: 'Email Updates',
              value: _emailUpdates,
              onChanged: (value) {
                setState(() {
                  _emailUpdates = value;
                  _saveSetting('email_updates', value);
                });
              },
            ),
            
            _buildSwitchTile(
              title: 'Promotional Offers',
              value: _promotionalOffers,
              onChanged: (value) {
                setState(() {
                  _promotionalOffers = value;
                  _saveSetting('promotional_offers', value);
                });
              },
            ),
            
            SizedBox(height: 24),
            
            // SECURITY & PRIVACY Section
            _buildSectionHeader('SECURITY & PRIVACY'),
            SizedBox(height: 8),
            
            _buildSwitchTile(
              title: 'Biometric Login',
              value: _biometricLogin,
              onChanged: (value) {
                setState(() {
                  _biometricLogin = value;
                  _saveSetting('biometric_login', value);
                });
              },
            ),
            
            _buildNavTile(
              title: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              onTap: () {
                _showSnackBar('Open Privacy Policy');
              },
            ),
            
            _buildNavTile(
              title: 'Terms of Service',
              icon: Icons.description_outlined,
              onTap: () {
                _showSnackBar('Open Terms of Service');
              },
            ),
            
            SizedBox(height: 24),
            
            // APP PREFERENCES Section
            _buildSectionHeader('APP PREFERENCES'),
            SizedBox(height: 8),
            
            _buildLanguageTile(
              title: 'Language',
              value: _selectedLanguage,
              onTap: _showLanguageDialog,
            ),
            
            _buildSwitchTile(
              title: 'Dark Mode',
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                  _saveSetting('dark_mode', value);
                });
              },
            ),
            
            _buildClearCacheTile(
              title: 'Clear Cache',
              onClear: _clearCache,
            ),
            
            SizedBox(height: 24),
            
            // SUPPORT Section
            _buildSectionHeader('SUPPORT'),
            SizedBox(height: 8),
            
            _buildNavTile(
              title: 'Help Center',
              icon: Icons.help_outline,
              onTap: () {
                _showSnackBar('Open Help Center');
              },
            ),
            
            _buildNavTile(
              title: 'Contact Us',
              icon: Icons.contact_support_outlined,
              onTap: () {
                _showSnackBar('Open Contact Us');
              },
            ),
            
            _buildVersionTile(
              title: 'App Version',
              value: _appVersion,
            ),
            
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF8E2DE2),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF8E2DE2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Color(0xFF8E2DE2), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF8E2DE2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            title == 'Push Notification' ? Icons.notifications_outlined :
            title == 'Email Updates' ? Icons.email_outlined :
            title == 'Promotional Offers' ? Icons.local_offer_outlined :
            title == 'Biometric Login' ? Icons.fingerprint :
            title == 'Dark Mode' ? Icons.dark_mode_outlined :
            Icons.settings_outlined,
            color: Color(0xFF8E2DE2),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF8E2DE2),
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF8E2DE2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Color(0xFF8E2DE2), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLanguageTile({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF8E2DE2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.language, color: Color(0xFF8E2DE2), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildClearCacheTile({
    required String title,
    required VoidCallback onClear,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF8E2DE2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.cleaning_services_outlined, color: Color(0xFF8E2DE2), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: ElevatedButton(
          onPressed: onClear,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(0, 0),
          ),
          child: Text(
            'CLEAR',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildVersionTile({
    required String title,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF8E2DE2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.info_outline, color: Color(0xFF8E2DE2), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}