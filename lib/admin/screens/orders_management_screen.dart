import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersManagementScreen extends StatefulWidget {
  @override
  _OrdersManagementScreenState createState() => _OrdersManagementScreenState();
}

class _OrdersManagementScreenState extends State<OrdersManagementScreen> {
  List<Map<String, dynamic>> _orders = [];
  String _searchQuery = '';
  String _selectedStatus = 'All';
  bool _isLoading = true;
  
  final List<String> _statuses = ['All', 'pending', 'processing', 'shipped', 'delivered', 'cancelled'];
  
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }
  
  void _loadOrders() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _orders = [
          {'id': 'ORD-001', 'customer': 'John Doe', 'date': DateTime.now().subtract(Duration(days: 1)), 'amount': 4500, 'status': 'pending', 'items': 3},
          {'id': 'ORD-002', 'customer': 'Jane Smith', 'date': DateTime.now().subtract(Duration(days: 2)), 'amount': 8900, 'status': 'delivered', 'items': 2},
          {'id': 'ORD-003', 'customer': 'Mike Johnson', 'date': DateTime.now().subtract(Duration(days: 3)), 'amount': 12500, 'status': 'shipped', 'items': 4},
          {'id': 'ORD-004', 'customer': 'Sarah Wilson', 'date': DateTime.now().subtract(Duration(days: 4)), 'amount': 3200, 'status': 'pending', 'items': 1},
          {'id': 'ORD-005', 'customer': 'David Brown', 'date': DateTime.now().subtract(Duration(days: 5)), 'amount': 6700, 'status': 'delivered', 'items': 2},
        ];
        _isLoading = false;
      });
    });
  }
  
  List<Map<String, dynamic>> get _filteredOrders {
    return _orders.where((order) {
      final matchesSearch = order['customer'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'All' || order['status'] == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }
  
  int get _totalRevenue {
    int sum = 0;
    for (var order in _orders) {
      sum += order['amount'] as int;
    }
    return sum;
  }
  
  int get _pendingCount {
    return _orders.where((o) => o['status'] == 'pending').length;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text('Orders Management'),
        backgroundColor: Color(0xFF915BEE),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator(color: Color(0xFF915BEE)))
          : Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Stats Cards
                  Row(
                    children: [
                      _buildStatCard('Total Orders', _orders.length.toString(), Icons.shopping_cart, Color(0xFF6B48FF)),
                      SizedBox(width: 12),
                      _buildStatCard('Pending', _pendingCount.toString(), Icons.pending_actions, Color(0xFFFF9800)),
                      SizedBox(width: 12),
                      _buildStatCard('Revenue', '₱${NumberFormat('#,###').format(_totalRevenue)}', Icons.attach_money, Color(0xFF915BEE)),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Search Bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search by order ID or customer...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Status Filter
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _statuses.length,
                      itemBuilder: (context, index) {
                        final status = _statuses[index];
                        final isSelected = _selectedStatus == status;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedStatus = status),
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Color(0xFF915BEE) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xFF915BEE).withOpacity(0.3)),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : Color(0xFF915BEE),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Orders List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = _filteredOrders[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order['status']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(_getStatusIcon(order['status']), color: _getStatusColor(order['status']), size: 24),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order['id'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Text(order['customer'], style: TextStyle(color: Colors.grey[600])),
                                    Text('${order['items']} items • ${DateFormat('MMM dd, yyyy').format(order['date'])}', 
                                        style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('₱${NumberFormat('#,###').format(order['amount'])}', 
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF915BEE))),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(order['status']).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      order['status'].toUpperCase(),
                                      style: TextStyle(fontSize: 10, color: _getStatusColor(order['status']), fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.visibility, color: Colors.blue),
                                onPressed: () => _showOrderDetails(order),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return Colors.green;
      case 'shipped': return Colors.blue;
      case 'processing': return Color(0xFF915BEE);
      case 'pending': return Colors.orange;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
  
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return Icons.check_circle;
      case 'shipped': return Icons.local_shipping;
      case 'processing': return Icons.hourglass_empty;
      case 'pending': return Icons.pending;
      case 'cancelled': return Icons.cancel;
      default: return Icons.receipt;
    }
  }
  
  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    color: _getStatusColor(order['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(_getStatusIcon(order['status']), color: _getStatusColor(order['status']), size: 30),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Text(order['id'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(order['customer'], style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Divider(height: 24),
              _buildDetailRow('Order Date', DateFormat('MMM dd, yyyy').format(order['date'])),
              _buildDetailRow('Items', '${order['items']} products'),
              _buildDetailRow('Total Amount', '₱${NumberFormat('#,###').format(order['amount'])}'),
              _buildDetailRow('Status', order['status'].toUpperCase()),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF915BEE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}