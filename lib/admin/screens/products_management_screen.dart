import 'package:flutter/material.dart';

class ProductsManagementScreen extends StatefulWidget {
  @override
  _ProductsManagementScreenState createState() => _ProductsManagementScreenState();
}

class _ProductsManagementScreenState extends State<ProductsManagementScreen> {
  final List<Map<String, dynamic>> _products = [
    {
      'id': 'PRD-001',
      'name': 'School Uniform',
      'category': 'Uniforms',
      'price': 45000,
      'stock': 120,
      'status': 'Active',
    },
    {
      'id': 'PRD-002',
      'name': 'Hospital Gown',
      'category': 'Medical',
      'price': 38000,
      'stock': 85,
      'status': 'Active',
    },
    {
      'id': 'PRD-003',
      'name': 'Construction Wear',
      'category': 'Industrial',
      'price': 50000,
      'stock': 45,
      'status': 'Low Stock',
    },
    {
      'id': 'PRD-004',
      'name': 'Chef Coat',
      'category': 'Hospitality',
      'price': 55000,
      'stock': 60,
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Products Management'),
        backgroundColor: Color(0xFF915BEE),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showProductDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                DropdownButton<String>(
                  hint: Text('Category'),
                  items: ['All', 'Uniforms', 'Medical', 'Industrial', 'Hospitality']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color(0xFF915BEE).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.shopping_bag, size: 30, color: Color(0xFF915BEE)),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${product['id']} • Category: ${product['category']}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStockColor(product['stock']).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Stock: ${product['stock']}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: _getStockColor(product['stock']),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(product['status']).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          product['status'],
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: _getStatusColor(product['status']),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'UGX ${product['price']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF915BEE),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, size: 18),
                                      onPressed: () {
                                        _showProductDialog(product: product);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, size: 18, color: Colors.red),
                                      onPressed: () {
                                        _deleteProduct(index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDialog({Map<String, dynamic>? product}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Product Name'),
                controller: TextEditingController(text: product?['name']),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Category'),
                controller: TextEditingController(text: product?['category']),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: product?['price']?.toString()),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: product?['stock']?.toString()),
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
              // Save product
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Product'),
        content: Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getStockColor(int stock) {
    if (stock < 50) return Colors.red;
    if (stock < 100) return Colors.orange;
    return Colors.green;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Low Stock':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}