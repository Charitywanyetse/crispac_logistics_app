import 'package:flutter/material.dart';

class InventoryManagementScreen extends StatefulWidget {
  @override
  _InventoryManagementScreenState createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Fabrics', 'Threads', 'Accessories', 'Low Stock'];
  
  final List<Map<String, dynamic>> _inventory = [
    {
      'id': 'INV-001',
      'name': 'Cotton Fabric - White',
      'category': 'Fabrics',
      'quantity': 250,
      'unit': 'yards',
      'reorder_level': 50,
      'supplier': 'Textile Co.',
      'price': 12000,
      'last_ordered': '2024-03-20',
    },
    {
      'id': 'INV-002',
      'name': 'Silk Fabric - Red',
      'category': 'Fabrics',
      'quantity': 80,
      'unit': 'yards',
      'reorder_level': 30,
      'supplier': 'Luxury Textiles',
      'price': 35000,
      'last_ordered': '2024-03-15',
    },
    {
      'id': 'INV-003',
      'name': 'Polyester Thread - Black',
      'category': 'Threads',
      'quantity': 45,
      'unit': 'spools',
      'reorder_level': 20,
      'supplier': 'Sewing Supplies',
      'price': 2500,
      'last_ordered': '2024-03-18',
    },
    {
      'id': 'INV-004',
      'name': 'Metal Buttons - Gold',
      'category': 'Accessories',
      'quantity': 120,
      'unit': 'pieces',
      'reorder_level': 50,
      'supplier': 'Button World',
      'price': 500,
      'last_ordered': '2024-03-10',
    },
    {
      'id': 'INV-005',
      'name': 'Cotton Fabric - Blue',
      'category': 'Fabrics',
      'quantity': 35,
      'unit': 'yards',
      'reorder_level': 40,
      'supplier': 'Textile Co.',
      'price': 12000,
      'last_ordered': '2024-03-05',
    },
  ];

  List<Map<String, dynamic>> get _filteredInventory {
    if (_selectedTab == 0) return _inventory;
    if (_selectedTab == 4) return _inventory.where((item) => item['quantity'] <= item['reorder_level']).toList();
    return _inventory.where((item) => item['category'] == _tabs[_selectedTab]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Inventory Management'),
        backgroundColor: Color(0xFF915BEE),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showInventoryDialog(),
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              onTap: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              indicatorColor: Color(0xFF915BEE),
              labelColor: Color(0xFF915BEE),
              unselectedLabelColor: Colors.grey,
            ),
          ),
          
          // Stats
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Total Items', _inventory.length.toString(), Icons.inventory, Colors.blue),
                _buildStat('Low Stock', _inventory.where((i) => i['quantity'] <= i['reorder_level']).length.toString(), Icons.warning, Colors.orange),
                _buildStat('Categories', '4', Icons.category, Color(0xFF915BEE)),
              ],
            ),
          ),
          
          // Inventory List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredInventory.length,
              itemBuilder: (context, index) {
                final item = _filteredInventory[index];
                final isLowStock = item['quantity'] <= item['reorder_level'];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: _getCategoryColor(item['category']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getCategoryIcon(item['category']),
                                color: _getCategoryColor(item['category']),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${item['id']} • ${item['category']}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isLowStock ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Stock: ${item['quantity']} ${item['unit']}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isLowStock ? Colors.red : Colors.green,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      if (isLowStock)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Reorder Soon',
                                            style: TextStyle(fontSize: 11, color: Colors.orange),
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
                                  'UGX ${NumberFormat('#,###').format(item['price'])}/${item['unit']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF915BEE),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, size: 18),
                                      onPressed: () => _showInventoryDialog(item: item),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_shopping_cart, size: 18),
                                      onPressed: () => _showReorderDialog(item),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Stock Level Bar
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: item['quantity'] / (item['reorder_level'] * 3),
                          backgroundColor: Colors.grey[200],
                          color: isLowStock ? Colors.red : Colors.green,
                          minHeight: 4,
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

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }

  void _showInventoryDialog({Map<String, dynamic>? item}) {
    final nameController = TextEditingController(text: item?['name']);
    final quantityController = TextEditingController(text: item?['quantity']?.toString());
    final priceController = TextEditingController(text: item?['price']?.toString());
    String selectedCategory = item?['category'] ?? 'Fabrics';
    String selectedUnit = item?['unit'] ?? 'yards';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item == null ? 'Add Inventory Item' : 'Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: ['Fabrics', 'Threads', 'Accessories']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedUnit,
                decoration: InputDecoration(labelText: 'Unit'),
                items: ['yards', 'spools', 'pieces', 'meters']
                    .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                    .toList(),
                onChanged: (value) {
                  selectedUnit = value!;
                },
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price per Unit'),
                keyboardType: TextInputType.number,
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
              // Save inventory
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showReorderDialog(Map<String, dynamic> item) {
    final quantityController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Reorder ${item['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current stock: ${item['quantity']} ${item['unit']}'),
            Text('Reorder level: ${item['reorder_level']} ${item['unit']}'),
            SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Order Quantity',
                hintText: 'Enter quantity to order',
              ),
              keyboardType: TextInputType.number,
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
              Navigator.pop(context);
              // Process reorder
            },
            child: Text('Place Order'),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Fabrics':
        return Colors.blue;
      case 'Threads':
        return Colors.green;
      case 'Accessories':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Fabrics':
        return Icons.brush;
      case 'Threads':
        return Icons.timeline;
      case 'Accessories':
        return Icons.style;
      default:
        return Icons.inventory;
    }
  }
}