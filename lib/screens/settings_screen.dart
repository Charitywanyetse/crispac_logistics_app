import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ===== STATE VARIABLES =====
  bool _isLoading = false;
  
  // Wage Meter settings
  Map<String, dynamic> _wageMeter = {
    'hourlyRate': 25.00,
    'currency': 'USD',
    'overtimeRate': 1.5,
  };
  
  // Product Decision settings
  Map<String, dynamic> _productDecision = {
    'autoApprove': false,
    'minStockLevel': 10,
    'reorderQuantity': 50,
  };
  
  // Business Branding
  Map<String, dynamic> _businessBranding = {
    'companyName': 'Crispac Logistics',
    'tagline': 'Excellence in Motion',
    'primaryColor': '#6B48FF',
  };
  
  // User Experience settings
  Map<String, dynamic> _userExperience = {
    'animationsEnabled': true,
    'gestureNavigation': true,
    'hapticFeedback': true,
  };
  
  // Website settings
  Map<String, dynamic> _websiteSettings = {
    'autoSync': true,
    'cacheEnabled': true,
    'offlineMode': false,
  };
  
  // Wage Meter template URLs
  String _editWageUrl = 'https://example.com/edit-wage';
  String _wageMeterTemplateUrl = 'https://example.com/wage-template';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      // Load all settings from shared preferences
      setState(() {
        _wageMeter['hourlyRate'] = prefs.getDouble('hourlyRate') ?? 25.00;
        _wageMeter['currency'] = prefs.getString('currency') ?? 'USD';
        _productDecision['autoApprove'] = prefs.getBool('autoApprove') ?? false;
        _businessBranding['companyName'] = prefs.getString('companyName') ?? 'Crispac Logistics';
        _userExperience['animationsEnabled'] = prefs.getBool('animationsEnabled') ?? true;
        _websiteSettings['autoSync'] = prefs.getBool('autoSync') ?? true;
      });
    } catch (e) {
      _showSnackBar('Error loading settings: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.set(key, value);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showEditDialog(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                _showSnackBar('$title updated');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF915BEE),
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _openUrl(String url) {
    // TODO: Implement URL launcher
    _showSnackBar('Opening: $url');
  }

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
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      SizedBox(height: 16),
                      
                      // Title
                      Text(
                        'Design',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Customize your experience',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Settings Content
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
                        // Wage Meter Section
                        _buildSectionHeader(
                          title: "components",
                          subtitle: "Wage Meter",
                          icon: Icons.speed_outlined,
                        ),
                        _buildSettingsCard(
                          icon: Icons.attach_money,
                          title: "Hourly Rate",
                          value: "${_wageMeter['currency']} ${_wageMeter['hourlyRate']}/hr",
                          onEdit: () => _showEditDialog(
                            'Edit Hourly Rate',
                            _wageMeter['hourlyRate'].toString(),
                            (value) {
                              setState(() {
                                _wageMeter['hourlyRate'] = double.parse(value);
                                _saveSetting('hourlyRate', double.parse(value));
                              });
                            },
                          ),
                          onDelete: () {
                            setState(() {
                              _wageMeter['hourlyRate'] = 0;
                              _saveSetting('hourlyRate', 0);
                            });
                            _showSnackBar('Hourly rate reset');
                          },
                        ),
                        _buildSettingsCard(
                          icon: Icons.currency_exchange,
                          title: "Currency",
                          value: _wageMeter['currency'],
                          onEdit: () => _showEditDialog(
                            'Edit Currency',
                            _wageMeter['currency'],
                            (value) {
                              setState(() {
                                _wageMeter['currency'] = value;
                                _saveSetting('currency', value);
                              });
                            },
                          ),
                          onDelete: () {
                            setState(() {
                              _wageMeter['currency'] = 'USD';
                              _saveSetting('currency', 'USD');
                            });
                            _showSnackBar('Currency reset to USD');
                          },
                        ),
                        _buildSettingsCard(
                          icon: Icons.timer,
                          title: "Overtime Rate",
                          value: "${_wageMeter['overtimeRate']}x",
                          onEdit: () => _showEditDialog(
                            'Edit Overtime Rate',
                            _wageMeter['overtimeRate'].toString(),
                            (value) {
                              setState(() {
                                _wageMeter['overtimeRate'] = double.parse(value);
                              });
                            },
                          ),
                          onDelete: () {
                            setState(() {
                              _wageMeter['overtimeRate'] = 1.5;
                            });
                            _showSnackBar('Overtime rate reset');
                          },
                        ),

                        SizedBox(height: 32),

                        // Product Decision Section
                        _buildSectionHeader(
                          title: "decisions",
                          subtitle: "Product Decision",
                          icon: Icons.analytics_outlined,
                        ),
                        _buildSwitchCard(
                          icon: Icons.auto_awesome,
                          title: "Auto Approve Orders",
                          value: _productDecision['autoApprove'],
                          onChanged: (value) {
                            setState(() {
                              _productDecision['autoApprove'] = value;
                              _saveSetting('autoApprove', value);
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _productDecision['autoApprove'] = false;
                              _saveSetting('autoApprove', false);
                            });
                            _showSnackBar('Auto approve disabled');
                          },
                        ),
                        _buildSettingsCard(
                          icon: Icons.inventory,
                          title: "Minimum Stock Level",
                          value: "${_productDecision['minStockLevel']} units",
                          onEdit: () => _showEditDialog(
                            'Edit Minimum Stock',
                            _productDecision['minStockLevel'].toString(),
                            (value) {
                              setState(() {
                                _productDecision['minStockLevel'] = int.parse(value);
                              });
                            },
                          ),
                          onDelete: () {
                            setState(() {
                              _productDecision['minStockLevel'] = 10;
                            });
                            _showSnackBar('Stock level reset to 10');
                          },
                        ),
                        _buildSettingsCard(
                          icon: Icons.shopping_cart,
                          title: "Reorder Quantity",
                          value: "${_productDecision['reorderQuantity']} units",
                          onEdit: () => _showEditDialog(
                            'Edit Reorder Quantity',
                            _productDecision['reorderQuantity'].toString(),
                            (value) {
                              setState(() {
                                _productDecision['reorderQuantity'] = int.parse(value);
                              });
                            },
                          ),
                          onDelete: () {
                            setState(() {
                              _productDecision['reorderQuantity'] = 50;
                            });
                            _showSnackBar('Reorder quantity reset');
                          },
                        ),

                        SizedBox(height: 32),

                        // Business Branding Section
                        _buildSectionHeader(
                          title: "business",
                          subtitle: "Branding",
                          icon: Icons.business_outlined,
                        ),
                        _buildSettingsCard(
                          icon: Icons.business,
                          title: "Company Name",
                          value: _businessBranding['companyName'],
                          onEdit: () => _showEditDialog(
                            'Edit Company Name',
                            _businessBranding['companyName'],
                            (value) {
                              setState(() {
                                _businessBranding['companyName'] = value;
                                _saveSetting('companyName', value);
                              });
                            },
                          ),
                          onDelete: () {
                            setState(() {
                              _businessBranding['companyName'] = 'Crispac Logistics';
                              _saveSetting('companyName', 'Crispac Logistics');
                            });
                            _showSnackBar('Company name reset');
                          },
                        ),
                        _buildSettingsCard(
                          icon: Icons.tag,
                          title: "Tagline",
                          value: _businessBranding['tagline'],
                          onEdit: () => _showEditDialog(
                            'Edit Tagline',
                            _businessBranding['tagline'],
                            (value) {
                              setState(() {
                                _businessBranding['tagline'] = value;
                              });
                            },
                          ),
                          onDelete: () {
                            setState(() {
                              _businessBranding['tagline'] = 'Excellence in Motion';
                            });
                            _showSnackBar('Tagline reset');
                          },
                        ),
                        _buildColorPickerCard(
                          icon: Icons.color_lens,
                          title: "Primary Color",
                          color: Color(int.parse(_businessBranding['primaryColor'].replaceFirst('#', '0xFF'))),
                          onEdit: () {
                            // TODO: Implement color picker
                            _showSnackBar('Color picker coming soon');
                          },
                          onDelete: () {
                            setState(() {
                              _businessBranding['primaryColor'] = '#6B48FF';
                            });
                            _showSnackBar('Color reset to default');
                          },
                        ),

                        SizedBox(height: 32),

                        // User Experience Section
                        _buildSectionHeader(
                          title: "user experience",
                          subtitle: "Wage Meter",
                          icon: Icons.people_outline,
                        ),
                        _buildSwitchCard(
                          icon: Icons.animation,
                          title: "Animations",
                          value: _userExperience['animationsEnabled'],
                          onChanged: (value) {
                            setState(() {
                              _userExperience['animationsEnabled'] = value;
                              _saveSetting('animationsEnabled', value);
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _userExperience['animationsEnabled'] = true;
                              _saveSetting('animationsEnabled', true);
                            });
                            _showSnackBar('Animations enabled');
                          },
                        ),
                        _buildSwitchCard(
                          icon: Icons.swipe,
                          title: "Gesture Navigation",
                          value: _userExperience['gestureNavigation'],
                          onChanged: (value) {
                            setState(() {
                              _userExperience['gestureNavigation'] = value;
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _userExperience['gestureNavigation'] = true;
                            });
                            _showSnackBar('Gesture navigation enabled');
                          },
                        ),
                        _buildSwitchCard(
                          icon: Icons.tactile,
                          title: "Haptic Feedback",
                          value: _userExperience['hapticFeedback'],
                          onChanged: (value) {
                            setState(() {
                              _userExperience['hapticFeedback'] = value;
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _userExperience['hapticFeedback'] = true;
                            });
                            _showSnackBar('Haptic feedback enabled');
                          },
                        ),

                        SizedBox(height: 32),

                        // Website Section
                        _buildSectionHeader(
                          title: "website",
                          subtitle: "Web Client",
                          icon: Icons.web_outlined,
                        ),
                        _buildSwitchCard(
                          icon: Icons.sync,
                          title: "Auto Sync",
                          value: _websiteSettings['autoSync'],
                          onChanged: (value) {
                            setState(() {
                              _websiteSettings['autoSync'] = value;
                              _saveSetting('autoSync', value);
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _websiteSettings['autoSync'] = true;
                              _saveSetting('autoSync', true);
                            });
                            _showSnackBar('Auto sync enabled');
                          },
                        ),
                        _buildSwitchCard(
                          icon: Icons.storage,
                          title: "Cache Data",
                          value: _websiteSettings['cacheEnabled'],
                          onChanged: (value) {
                            setState(() {
                              _websiteSettings['cacheEnabled'] = value;
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _websiteSettings['cacheEnabled'] = true;
                            });
                            _showSnackBar('Cache enabled');
                          },
                        ),
                        _buildSwitchCard(
                          icon: Icons.offline_bolt,
                          title: "Offline Mode",
                          value: _websiteSettings['offlineMode'],
                          onChanged: (value) {
                            setState(() {
                              _websiteSettings['offlineMode'] = value;
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _websiteSettings['offlineMode'] = false;
                            });
                            _showSnackBar('Offline mode disabled');
                          },
                        ),

                        SizedBox(height: 32),

                        // External Links
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8F9FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Resources',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 12),
                              _buildLinkTile(
                                icon: Icons.edit,
                                title: 'Edit wage',
                                url: _editWageUrl,
                              ),
                              Divider(height: 1),
                              _buildLinkTile(
                                icon: Icons.insert_chart,
                                title: 'Wage meter template',
                                url: _wageMeterTemplateUrl,
                              ),
                            ],
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

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF915BEE).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xFF915BEE), size: 24),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF915BEE), size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 20, color: Colors.red[400]),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF915BEE), size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF915BEE),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 20, color: Colors.red[400]),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildColorPickerCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF915BEE), size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: 40,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 20, color: Colors.red[400]),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required String url,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF915BEE)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.open_in_new, size: 18, color: Colors.grey[400]),
      onTap: () => _openUrl(url),
      dense: true,
    );
  }
}