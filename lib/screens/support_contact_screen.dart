import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportContactScreen extends StatelessWidget {
  final String supportPhone = '+256 123 456 789';
  final String supportEmail = 'support@crispaclogistics.com';

  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: supportPhone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=Support Request&body=Hello, I need help with...',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Color(0xFF915BEE),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.support_agent, size: 60, color: Color(0xFF915BEE)),
                  SizedBox(height: 16),
                  Text(
                    'We are here to help!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Reach out to us via phone or email. Our support team is available 24/7.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  ListTile(
                    leading: Icon(Icons.phone, color: Color(0xFF915BEE)),
                    title: Text(supportPhone),
                    trailing: Icon(Icons.call),
                    onTap: _makePhoneCall,
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email, color: Color(0xFF915BEE)),
                    title: Text(supportEmail),
                    trailing: Icon(Icons.open_in_new),
                    onTap: _sendEmail,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _buildFaqTile(
                      'How do I track my order?',
                      'You can track your order in the Orders tab.'),
                  _buildFaqTile(
                      'What is your return policy?',
                      'Items can be returned within 14 days of delivery.'),
                  _buildFaqTile(
                      'How do I change my delivery address?',
                      'Update your address in Profile → Edit Profile.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: TextStyle(fontWeight: FontWeight.w500)),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(answer),
        ),
      ],
    );
  }
}