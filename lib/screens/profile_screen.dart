import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User information
  String _firstName = 'Alexander';
  String _lastName = 'Sterling';
  String _fullName = 'Alexander Alexis Sterling';
  String _role = 'Administrateur';
  String _email = 'a.sterling@creepac.com';
  String _phone = '+33 (0)1 803 - 9412';
  String _clientStatus = 'Banking Client Status';
  
  // Addresses
  String _primaryResidence = '01, rue du Père, 5, 01000 Paris';
  String _regionalOffice = '100 boulevard Raspail, Rue S, 01000 PARIS';
  
  // Notifications
  bool _bilanActivites = false;
  bool _dossierControle = false;
  bool _ressourcesClients = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text(
          'Creepac Logisteres',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF8E2DE2),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Color(0xFF8E2DE2)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Name and Role
            Container(
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
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF8E2DE2),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Alexander Sterling',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'President/Ingénieur de l\'IA',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '2017',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Votre Nom :',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _lastName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Votre Prénom :',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _firstName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Information Section
                  _buildSectionHeader('Account information'),
                  SizedBox(height: 12),
                  _buildInfoCard([
                    _InfoItem('Nom :', _fullName),
                    _InfoItem('Classe :', _role),
                    _InfoItem('Adresse :', _email),
                    _InfoItem('Tél :', _phone),
                    _InfoItem('Numéro :', _clientStatus),
                  ]),

                  SizedBox(height: 24),

                  // Addresses Section
                  _buildSectionHeader('Addresses'),
                  SizedBox(height: 12),
                  _buildAddressCard(
                    title: 'Primary Residence',
                    address: _primaryResidence,
                  ),
                  SizedBox(height: 12),
                  _buildAddressCard(
                    title: 'Regional Office',
                    address: _regionalOffice,
                  ),

                  SizedBox(height: 24),

                  // Notifications Section
                  _buildSectionHeader('Notifications'),
                  SizedBox(height: 12),
                  _buildNotificationCard([
                    _NotificationItem(
                      title: 'Bilan d\'activités',
                      value: _bilanActivites,
                      onChanged: (value) {
                        setState(() {
                          _bilanActivites = value ?? false;
                        });
                      },
                    ),
                    _NotificationItem(
                      title: 'Dossier Contrôle',
                      value: _dossierControle,
                      onChanged: (value) {
                        setState(() {
                          _dossierControle = value ?? false;
                        });
                      },
                    ),
                    _NotificationItem(
                      title: 'Ressources Clients',
                      value: _ressourcesClients,
                      onChanged: (value) {
                        setState(() {
                          _ressourcesClients = value ?? false;
                        });
                      },
                    ),
                  ]),

                  SizedBox(height: 24),

                  // Account Actions Section
                  _buildSectionHeader('Account Actions'),
                  SizedBox(height: 12),
                  _buildAccountActionCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoCard(List<_InfoItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddressCard({
    required String title,
    required String address,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: Color(0xFF8E2DE2), size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            address,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(List<_NotificationItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Checkbox(
                  value: item.value,
                  onChanged: item.onChanged,
                  activeColor: Color(0xFF8E2DE2),
                  side: BorderSide(color: Colors.grey[400]!),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccountActionCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF8E2DE2).withOpacity(0.1),
            Color(0xFF6B48FF).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF8E2DE2).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign up for your account or manage your banking profile here!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bonjour !',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8E2DE2),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _showSnackBar('Login feature coming soon');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8E2DE2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;
  
  _InfoItem(this.label, this.value);
}

class _NotificationItem {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  
  _NotificationItem({
    required this.title,
    required this.value,
    required this.onChanged,
  });
}