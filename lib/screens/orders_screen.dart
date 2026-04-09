import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Gradient
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
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Track Orders',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Status',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '1,284',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '(Total: 3)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Order Details'),
                  SizedBox(height: 8),
                  _buildInfoCard(
                    title: 'Order ID:',
                    value: 'CPB-HE29',
                  ),
                  SizedBox(height: 8),
                  _buildInfoCard(
                    title: 'Status:',
                    value: 'In Progress',
                    valueColor: Color(0xFF8E2DE2),
                  ),

                  SizedBox(height: 24),
                  _buildSectionHeader('Payment Method'),
                  SizedBox(height: 8),
                  _buildInfoCard(
                    title: 'PayPal',
                    value: 'Withdrawals via PayPal are not supported',
                    isNote: true,
                  ),

                  SizedBox(height: 24),
                  _buildSectionHeader('Shipping Options'),
                  SizedBox(height: 8),
                  _buildInfoCard(
                    title: 'Express Delivery',
                    value: 'Express delivery is available for orders over \$50',
                    isNote: true,
                  ),

                  SizedBox(height: 24),
                  _buildSectionHeader('Delivery Time'),
                  SizedBox(height: 8),
                  _buildInfoCard(
                    title: '2-5 Days',
                    value: 'Delivery time may vary depending on the shipping method used',
                    isNote: true,
                  ),

                  SizedBox(height: 24),
                  _buildSectionHeader('Return Policy'),
                  SizedBox(height: 8),
                  _buildInfoCard(
                    title: 'No Returns',
                    value: 'Returns are not accepted',
                    isNote: true,
                  ),

                  SizedBox(height: 24),
                  _buildSectionHeader('Shipping Costs'),
                  SizedBox(height: 8),
                  _buildInfoCard(
                    title: '\$0.00',
                    value: 'Shipping costs are not included',
                    isNote: true,
                  ),

                  SizedBox(height: 24),
                  _buildSectionHeader('Additional Information'),
                  SizedBox(height: 8),
                  _buildInfoCard(
                    title: 'Additional information about the order:',
                    value: '(For further details)',
                    isNote: true,
                  ),

                  SizedBox(height: 24),
                  _buildSectionHeader("SLP's Shopify"),
                  SizedBox(height: 12),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.storefront,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  _buildSectionHeader('Global Coverage'),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      '(Select countries to see coverage in that region.)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  Container(
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
                      children: [
                        Text(
                          'Not Support?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'If you have any questions or need assistance, please contact us.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showSnackBar(context, 'Live chat support coming soon!');
                      },
                      icon: Icon(Icons.chat_bubble_outline, size: 20),
                      label: Text(
                        'Live Chat Support',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8E2DE2),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
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

  Widget _buildInfoCard({
    required String title,
    required String value,
    Color? valueColor,
    bool isNote = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
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
          if (value.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isNote ? 12 : 14,
                fontWeight: isNote ? FontWeight.normal : FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}