import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductsManagementScreen extends StatefulWidget {
  @override
  _ProductsManagementScreenState createState() => _ProductsManagementScreenState();
}

class _ProductsManagementScreenState extends State<ProductsManagementScreen> {
  List<Map<String, dynamic>> _products = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = true;
  
  final List<String> _categories = ['All', 'Formal Wear', 'Casual Wear', 'Uniforms', 'Accessories'];
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }
  
  void _loadProducts() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _products = [
          {'id': 'PRD-001', 'name': 'Barong Tagalog', 'category': 'Formal Wear', 'price': 4500.00, 'cost': 2500.00, 'stock': 45, 'min_stock': 10, 'status': 'In Stock'},
          {'id': 'PRD-002', 'name': 'Filipiniana Dress', 'category': 'Formal Wear', 'price': 6800.00, 'cost': 3800.00, 'stock': 32, 'min_stock': 8, 'status': 'In Stock'},
          {'id': 'PRD-003', 'name': 'Corporate Uniform', 'category': 'Uniforms', 'price': 3500.00, 'cost': 1800.00, 'stock': 18, 'min_stock': 20, 'status': 'Low Stock'},
          {'id': 'PRD-004', 'name': 'Kimona Blouse', 'category': 'Casual Wear', 'price': 2500.00, 'cost': 1200.00, 'stock': 67, 'min_stock': 15, 'status': 'In Stock'},
          {'id': 'PRD-005', 'name': 'Alampay Shawl', 'category': 'Accessories', 'price': 1800.00, 'cost': 800.00, 'stock': 23, 'min_stock': 5, 'status': 'In Stock'},
        ];
        _isLoading = false;
      });
    });
  }
  
  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((product) {
      final matchesSearch = product['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || product['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text('Products Management'),
        backgroundColor: Color(0xFF915BEE),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddProductDialog(),
          ),
        ],
      ),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator(color: Color(0xFF915BEE)))
          : Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Category Filter
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategory = category),
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Color(0xFF915BEE) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xFF915BEE).withOpacity(0.3)),
                            ),
                            child: Text(category, style: TextStyle(color: isSelected ? Colors.white : Color(0xFF915BEE))),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Products List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50, height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF915BEE).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.inventory_2, color: Color(0xFF915BEE), size: 24),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(product['id'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                    Text('Stock: ${product['stock']}', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('₱${NumberFormat('#,###').format(product['price'])}', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF915BEE))),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: product['status'] == 'In Stock' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(product['status'], style: TextStyle(fontSize: 10, color: product['status'] == 'In Stock' ? Colors.green : Colors.orange)),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditProductDialog(product),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteDialog(product),
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
  
  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Product Name')),
            SizedBox(height: 8),
            TextField(decoration: InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Add'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF915BEE))),
        ],
      ),
    );
  }
  
  void _showEditProductDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Product Name'), controller: TextEditingController(text: product['name'])),
            TextField(decoration: InputDecoration(labelText: 'Price'), controller: TextEditingController(text: product['price'].toString()), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Save'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF915BEE))),
        ],
      ),
    );
  }
  
  void _showDeleteDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Product'),
        content: Text('Delete ${product['name']}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Delete'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
        ],
      ),
    );
  }
}