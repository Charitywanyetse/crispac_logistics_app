import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ===== USER DATA =====
  String _userName = 'wanyetse charity';
  String _userEmail = 'wanyetse.charity@email.com';
  String _userPhone = '+256 (555) 123-4567';
  String _userAddress = 'uganda,kampala, bukoto';
  
  // ===== NOTIFICATION SETTINGS =====
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _deliveryUpdates = true;
  bool _promoNotifications = false;
  
  // ===== APP PREFERENCES =====
  bool _darkMode = false;
  String _selectedLanguage = 'English';
  bool _autoPlay = true;
  bool _saveData = false;
  
  // ===== PRIVACY SETTINGS =====
  bool _shareLocation = true;
  bool _showOnlineStatus = true;
  bool _twoFactorAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 169, 143, 247), // Your purple color
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveAllSettings(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          // ===== PROFILE SECTION (EDITABLE) =====
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9B7BFF), Color(0xFF7B5BFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF9B7BFF).withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Image (click to change)
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Text(
                          _userName[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9B7BFF),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showImageOptions(context),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Color(0xFF9B7BFF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Editable Name
                  _buildEditableField(
                    icon: Icons.person,
                    value: _userName,
                    label: 'Name',
                    onTap: () => _showEditDialog(
                      'Edit Name',
                      _userName,
                      (newValue) => setState(() => _userName = newValue),
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Editable Email
                  _buildEditableField(
                    icon: Icons.email,
                    value: _userEmail,
                    label: 'Email',
                    onTap: () => _showEditDialog(
                      'Edit Email',
                      _userEmail,
                      (newValue) => setState(() => _userEmail = newValue),
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Editable Phone
                  _buildEditableField(
                    icon: Icons.phone,
                    value: _userPhone,
                    label: 'Phone',
                    onTap: () => _showEditDialog(
                      'Edit Phone',
                      _userPhone,
                      (newValue) => setState(() => _userPhone = newValue),
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Editable Address
                  _buildEditableField(
                    icon: Icons.location_on,
                    value: _userAddress,
                    label: 'Address',
                    onTap: () => _showEditDialog(
                      'Edit Address',
                      _userAddress,
                      (newValue) => setState(() => _userAddress = newValue),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== ACCOUNT SECURITY =====
          _buildSectionTitle('Account Security'),
          
          _buildSettingsItem(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () => _showChangePasswordDialog(context),
          ),
          
          _buildSwitchItem(
            icon: Icons.fingerprint,
            title: 'Two-Factor Authentication',
            subtitle: 'Enhanced account security',
            value: _twoFactorAuth,
            onChanged: (value) => setState(() => _twoFactorAuth = value),
          ),

          // ===== NOTIFICATION PREFERENCES =====
          _buildSectionTitle('Notifications'),
          
          _buildSwitchItem(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive push notifications',
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
          ),
          
          _buildSwitchItem(
            icon: Icons.email_outlined,
            title: 'Email Notifications',
            subtitle: 'Receive email updates',
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
            enabled: _pushNotifications,
          ),
          
          _buildSwitchItem(
            icon: Icons.sms_outlined,
            title: 'SMS Notifications',
            subtitle: 'Receive text messages',
            value: _smsNotifications,
            onChanged: (value) => setState(() => _smsNotifications = value),
            enabled: _pushNotifications,
          ),
          
          _buildSwitchItem(
            icon: Icons.delivery_dining,
            title: 'Delivery Updates',
            subtitle: 'Get notified about delivery status',
            value: _deliveryUpdates,
            onChanged: (value) => setState(() => _deliveryUpdates = value),
          ),
          
          _buildSwitchItem(
            icon: Icons.local_offer,
            title: 'Promotions & Offers',
            subtitle: 'Receive special offers',
            value: _promoNotifications,
            onChanged: (value) => setState(() => _promoNotifications = value),
          ),

          // ===== APP PREFERENCES =====
          _buildSectionTitle('App Preferences'),
          
          _buildSwitchItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          
          _buildSettingsItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: _selectedLanguage,
            onTap: () => _showLanguageDialog(context),
          ),
          
          _buildSwitchItem(
            icon: Icons.play_circle_outline,
            title: 'Auto-play Videos',
            subtitle: 'Automatically play videos',
            value: _autoPlay,
            onChanged: (value) => setState(() => _autoPlay = value),
          ),
          
          _buildSwitchItem(
            icon: Icons.data_usage,
            title: 'Data Saver',
            subtitle: 'Reduce data usage',
            value: _saveData,
            onChanged: (value) => setState(() => _saveData = value),
          ),

          // ===== PRIVACY =====
          _buildSectionTitle('Privacy'),
          
          _buildSwitchItem(
            icon: Icons.location_on,
            title: 'Share Location',
            subtitle: 'Allow location access',
            value: _shareLocation,
            onChanged: (value) => setState(() => _shareLocation = value),
          ),
          
          _buildSwitchItem(
            icon: Icons.visibility,
            title: 'Show Online Status',
            subtitle: 'Let others see when you\'re online',
            value: _showOnlineStatus,
            onChanged: (value) => setState(() => _showOnlineStatus = value),
          ),

          // ===== ABOUT =====
          _buildSectionTitle('About'),
          
          _buildAboutItem(
            icon: Icons.info_outline,
            title: 'App Version',
            value: '1.0.0',
          ),
          
          _buildAboutItem(
            icon: Icons.update,
            title: 'Last Updated',
            value: 'March 4, 2026',
          ),
          
          _buildSettingsItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () => _showPrivacyPolicy(context),
          ),
          
          _buildSettingsItem(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms',
            onTap: () => _showTermsOfService(context),
          ),

          // ===== DANGER ZONE =====
          _buildSectionTitle('Danger Zone', isDanger: true),
          
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red),
                  title: Text('Delete Account', style: TextStyle(color: Colors.red)),
                  subtitle: Text('Permanently delete your account and data'),
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ],
            ),
          ),

          // ===== LOGOUT BUTTON =====
          Container(
            margin: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => _showLogoutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF9B7BFF),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Color(0xFF9B7BFF).withOpacity(0.3)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Color(0xFF9B7BFF)),
                  SizedBox(width: 8),
                  Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9B7BFF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===== HELPER WIDGETS =====

  Widget _buildEditableField({
    required IconData icon,
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool isDanger = false}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDanger ? Colors.red : Color(0xFF9B7BFF),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? Color(0xFF9B7BFF)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color ?? Color(0xFF9B7BFF), size: 22),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null 
        ? Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600]))
        : null,
      trailing: showArrow 
        ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])
        : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
    bool enabled = true,
  }) {
    return SwitchListTile(
      secondary: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (enabled ? Color(0xFF9B7BFF) : Colors.grey).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon, 
          color: enabled ? Color(0xFF9B7BFF) : Colors.grey,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: enabled ? Colors.black : Colors.grey,
        ),
      ),
      subtitle: subtitle != null 
        ? Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: enabled ? Colors.grey[600] : Colors.grey[400],
            ),
          )
        : null,
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: Color(0xFF9B7BFF),
    );
  }

  Widget _buildAboutItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.grey.shade700, size: 22),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text(
        value,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      ),
    );
  }

  // ===== DIALOGS =====

  void _showEditDialog(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new value',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onSave(controller.text);
                  Navigator.pop(context);
                  _showSnackBar(context, '$title updated successfully');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9B7BFF),
              ),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    TextEditingController oldPass = TextEditingController();
    TextEditingController newPass = TextEditingController();
    TextEditingController confirmPass = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPass,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: newPass,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: confirmPass,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
                if (newPass.text == confirmPass.text) {
                  Navigator.pop(context);
                  _showSnackBar(context, 'Password changed successfully');
                } else {
                  _showSnackBar(context, 'Passwords do not match', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9B7BFF),
              ),
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English', _selectedLanguage == 'English'),
              _buildLanguageOption('Spanish', _selectedLanguage == 'Spanish'),
              _buildLanguageOption('French', _selectedLanguage == 'French'),
              _buildLanguageOption('German', _selectedLanguage == 'German'),
              _buildLanguageOption('Chinese', _selectedLanguage == 'Chinese'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, bool isSelected) {
    return ListTile(
      title: Text(language),
      leading: isSelected 
        ? Icon(Icons.check_circle, color: Color(0xFF9B7BFF))
        : Icon(Icons.radio_button_unchecked, color: Colors.grey),
      onTap: () {
        setState(() => _selectedLanguage = language);
        Navigator.pop(context);
        _showSnackBar(context, 'Language changed to $language');
      },
    );
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF9B7BFF)),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar(context, 'Gallery opened');
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera, color: Color(0xFF9B7BFF)),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar(context, 'Camera opened');
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Remove Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar(context, 'Photo removed');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Privacy Policy'),
          content: Container(
            width: double.maxFinite,
            child: Text(
              'Your privacy is important to us. This privacy policy explains how we collect, use, and protect your personal information when you use our app.\n\n'
              '1. Information We Collect\n'
              '2. How We Use Your Information\n'
              '3. Data Security\n'
              '4. Your Rights\n'
              '5. Contact Us',
              style: TextStyle(height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms of Service'),
          content: Container(
            width: double.maxFinite,
            child: Text(
              'By using this app, you agree to these terms. Please read them carefully.\n\n'
              '1. Acceptance of Terms\n'
              '2. User Responsibilities\n'
              '3. Account Termination\n'
              '4. Limitation of Liability\n'
              '5. Changes to Terms',
              style: TextStyle(height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account', style: TextStyle(color: Colors.red)),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackBar(context, 'Account deleted', isError: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Delete Permanently'),
            ),
          ],
        );
      },
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _performLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  void _saveAllSettings(BuildContext context) {
    // Here you would save all settings to backend/shared preferences
    _showSnackBar(context, 'All settings saved successfully');
  }

  void _performLogout(BuildContext context) {
    _showSnackBar(context, 'Logged out successfully');
    // Navigate to login screen (you'll implement this)
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Color(0xFF9B7BFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}