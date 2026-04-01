import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomersManagementScreen extends StatefulWidget {
  @override
  _CustomersManagementScreenState createState() => _CustomersManagementScreenState();
}

class _CustomersManagementScreenState extends State<CustomersManagementScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  
  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'CUST-001',
      'name': 'John Doe',
      'email': 'john@example.com',
      'phone': '+256 123 456 789',
      'address': 'Kampala, Uganda',
      'orders': 12,
      'total_spent': 450000,
      'joined': '2024-01-15',
      'status': 'Active',
      'measurements': {
        'chest': 40,
        'waist': 32,
        'hips': 38,
        'shoulder': 18,
        'sleeve': 25,
        'length': 30,
      },
    },
    {
      'id': 'CUST-002',
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'phone': '+256 234 567 890',
      'address': 'Entebbe, Uganda',
      'orders': 8,
      'total_spent': 280000,
      'joined': '2024-02-10',
      'status': 'Active',
      'measurements': {
        'chest': 36,
        'waist': 28,
        'hips': 36,
        'shoulder': 16,
        'sleeve': 24,
        'length': 28,
      },
    },
    {
      'id': 'CUST-003',
      'name': 'Mike Johnson',
      'email': 'mike@example.com',
      'phone': '+256 345 678 901',
      'address': 'Jinja, Uganda',
      'orders': 5,
      'total_spent': 185000,
      'joined': '2024-02-20',
      'status': 'Inactive',
      'measurements': {
        'chest': 42,
        'waist': 34,
        'hips': 40,
        'shoulder': 19,
        'sleeve': 26,
        'length': 32,
      },
    },
  ];

  List<Map<String, dynamic>> get _filteredCustomers {
    return _customers.where((customer) {
      final matchesSearch = _searchQuery.isEmpty ||
          customer['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer['email'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer['phone'].contains(_searchQuery);
      
      final matchesFilter = _selectedFilter == 'All' || customer['status'] == _selectedFilter;
      
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Customers Management'),
        backgroundColor: Color(0xFF915BEE),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showCustomerDialog(),
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search customers...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Active', 'Inactive'].map((filter) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          selectedColor: Color(0xFF915BEE).withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: _selectedFilter == filter ? Color(0xFF915BEE) : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Stats Summary
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total Customers',
                  _customers.length.toString(),
                  Icons.people,
                  Color(0xFF915BEE),
                ),
                _buildStatItem(
                  'Active',
                  _customers.where((c) => c['status'] == 'Active').length.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatItem(
                  'Total Spent',
                  'UGX ${NumberFormat('#,###').format(_customers.fold<int>(0, (sum, c) => sum + c['total_spent']))}',
                  Icons.attach_money,
                  Colors.orange,
                ),
              ],
            ),
          ),
          
          // Customers List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF915BEE).withOpacity(0.1),
                      child: Text(
                        customer['name'][0],
                        style: TextStyle(color: Color(0xFF915BEE), fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      customer['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(customer['email']),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: customer['status'] == 'Active' 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        customer['status'],
                        style: TextStyle(
                          color: customer['status'] == 'Active' ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Customer Details
                            _buildDetailRow(Icons.phone, 'Phone', customer['phone']),
                            _buildDetailRow(Icons.location_on, 'Address', customer['address']),
                            _buildDetailRow(Icons.shopping_bag, 'Total Orders', customer['orders'].toString()),
                            _buildDetailRow(Icons.attach_money, 'Total Spent', 'UGX ${NumberFormat('#,###').format(customer['total_spent'])}'),
                            _buildDetailRow(Icons.calendar_today, 'Joined', customer['joined']),
                            
                            SizedBox(height: 16),
                            Divider(),
                            
                            // Measurements
                            Text(
                              'Measurements (inches)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              childAspectRatio: 2,
                              children: [
                                _buildMeasurementTile('Chest', customer['measurements']['chest']),
                                _buildMeasurementTile('Waist', customer['measurements']['waist']),
                                _buildMeasurementTile('Hips', customer['measurements']['hips']),
                                _buildMeasurementTile('Shoulder', customer['measurements']['shoulder']),
                                _buildMeasurementTile('Sleeve', customer['measurements']['sleeve']),
                                _buildMeasurementTile('Length', customer['measurements']['length']),
                              ],
                            ),
                            
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _editMeasurements(customer),
                                    icon: Icon(Icons.measure),
                                    label: Text('Update Measurements'),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _viewOrderHistory(customer),
                                    icon: Icon(Icons.history),
                                    label: Text('Order History'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF915BEE),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () => _showCustomerDialog(customer: customer),
                              icon: Icon(Icons.edit, size: 18),
                              label: Text('Edit Customer Details'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementTile(String label, int value) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF915BEE).withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF915BEE),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomerDialog({Map<String, dynamic>? customer}) {
    final nameController = TextEditingController(text: customer?['name']);
    final emailController = TextEditingController(text: customer?['email']);
    final phoneController = TextEditingController(text: customer?['phone']);
    final addressController = TextEditingController(text: customer?['address']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(customer == null ? 'Add Customer' : 'Edit Customer'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Save customer
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editMeasurements(Map<String, dynamic> customer) {
    final controllers = {
      'chest': TextEditingController(text: customer['measurements']['chest'].toString()),
      'waist': TextEditingController(text: customer['measurements']['waist'].toString()),
      'hips': TextEditingController(text: customer['measurements']['hips'].toString()),
      'shoulder': TextEditingController(text: customer['measurements']['shoulder'].toString()),
      'sleeve': TextEditingController(text: customer['measurements']['sleeve'].toString()),
      'length': TextEditingController(text: customer['measurements']['length'].toString()),
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Update Measurements - ${customer['name']}'),
        content: SizedBox(
          width: 300,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: controllers.entries.map((entry) {
              return TextField(
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: entry.key.toUpperCase(),
                  suffixText: 'in',
                ),
                keyboardType: TextInputType.number,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Save measurements
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _viewOrderHistory(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Order History - ${customer['name']}'),
        content: Container(
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text('Order #ORD-${1000 + index}'),
                subtitle: Text('UGX ${45000 + index * 10000}'),
                trailing: Text('${index + 1} items'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}