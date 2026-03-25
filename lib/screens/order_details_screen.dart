import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  final String orderStatus;

  OrderDetailsScreen({required this.orderId, required this.orderStatus});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _orderDetails;

  // Simulate API call to fetch order details
  Future<void> _fetchOrderDetails() async {
    setState(() => _isLoading = true);
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));
    // Mock data (replace with actual API call)
    final mockData = {
      'orderId': widget.orderId,
      'status': widget.orderStatus,
      'orderDate': DateTime.now().subtract(Duration(days: 2)),
      'estimatedDelivery': DateTime.now().add(Duration(days: 3)),
      'products': [
        {'name': 'School Uniform', 'quantity': 2, 'price': 45000},
        {'name': 'Hospital Gown', 'quantity': 1, 'price': 38000},
      ],
      'deliveryAddress': '123 Main Street, Mbale City',
      'phone': '+256 123 456 789',
      'subtotal': 128000,
      'shipping': 5000,
      'total': 133000,
    };
    setState(() {
      _orderDetails = mockData;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Shipped':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  double _getProgressValue(String status) {
    switch (status) {
      case 'Pending':
        return 0.3;
      case 'Shipped':
        return 0.7;
      case 'Delivered':
        return 1.0;
      default:
        return 0.0;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId}'),
        backgroundColor: Color(0xFF915BEE),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchOrderDetails,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  // Status card with progress
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(_orderDetails!['status']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _orderDetails!['status'],
                                  style: TextStyle(
                                    color: _getStatusColor(_orderDetails!['status']),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: _getProgressValue(_orderDetails!['status']),
                            backgroundColor: Colors.grey[200],
                            color: _getStatusColor(_orderDetails!['status']),
                            minHeight: 6,
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order Placed: ${_formatDate(_orderDetails!['orderDate'])}'),
                              Text('Est. Delivery: ${_formatDate(_orderDetails!['estimatedDelivery'])}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Products section
                  Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (_orderDetails!['products'] as List).length,
                    itemBuilder: (context, index) {
                      final product = _orderDetails!['products'][index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Icon(Icons.shopping_bag, color: Color(0xFF915BEE)),
                          title: Text(product['name']),
                          subtitle: Text('Quantity: ${product['quantity']}'),
                          trailing: Text(
                            'UGX ${(product['price'] * product['quantity']).toStringAsFixed(0)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  // Delivery address
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(_orderDetails!['deliveryAddress']),
                          Text('Phone: ${_orderDetails!['phone']}'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Order summary
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSummaryRow('Subtotal', 'UGX ${_orderDetails!['subtotal'].toStringAsFixed(0)}'),
                          SizedBox(height: 8),
                          _buildSummaryRow('Shipping', 'UGX ${_orderDetails!['shipping'].toStringAsFixed(0)}'),
                          Divider(),
                          _buildSummaryRow('Total', 'UGX ${_orderDetails!['total'].toStringAsFixed(0)}', isBold: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}