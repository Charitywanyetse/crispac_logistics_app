import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductionTrackingScreen extends StatefulWidget {
  @override
  _ProductionTrackingScreenState createState() => _ProductionTrackingScreenState();
}

class _ProductionTrackingScreenState extends State<ProductionTrackingScreen> {
  int _selectedStage = 0;
  final List<String> _stages = ['Cutting', 'Sewing', 'Finishing', 'Quality Check', 'Completed'];
  
  final List<Map<String, dynamic>> _productionOrders = [
    {
      'id': 'PRD-001',
      'order_id': 'ORD-1001',
      'garment': 'School Uniform',
      'customer': 'John Doe',
      'stage': 'Cutting',
      'progress': 30,
      'assigned_to': 'James',
      'start_date': '2024-03-25',
      'due_date': '2024-03-30',
      'priority': 'High',
      'notes': 'Rush order',
    },
    {
      'id': 'PRD-002',
      'order_id': 'ORD-1002',
      'garment': 'Hospital Gown',
      'customer': 'Jane Smith',
      'stage': 'Sewing',
      'progress': 60,
      'assigned_to': 'Mary',
      'start_date': '2024-03-24',
      'due_date': '2024-03-28',
      'priority': 'Medium',
      'notes': '',
    },
    {
      'id': 'PRD-003',
      'order_id': 'ORD-1003',
      'garment': 'Chef Coat',
      'customer': 'Mike Johnson',
      'stage': 'Finishing',
      'progress': 85,
      'assigned_to': 'Peter',
      'start_date': '2024-03-23',
      'due_date': '2024-03-27',
      'priority': 'Low',
      'notes': 'Special buttons',
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedStage == 4) {
      return _productionOrders.where((order) => order['stage'] == 'Completed').toList();
    }
    return _productionOrders.where((order) => order['stage'] == _stages[_selectedStage]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Production Tracking'),
        backgroundColor: Color(0xFF915BEE),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showProductionDialog(),
          ),
          IconButton(
            icon: Icon(Icons.timeline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Stage Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              tabs: _stages.map((stage) => Tab(text: stage)).toList(),
              onTap: (index) {
                setState(() {
                  _selectedStage = index;
                });
              },
              indicatorColor: Color(0xFF915BEE),
              labelColor: Color(0xFF915BEE),
              unselectedLabelColor: Colors.grey,
            ),
          ),
          
          // Production Stats
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
                _buildStat('In Production', '12', Icons.factory, Colors.blue),
                _buildStat('Today\'s Target', '8', Icons.today, Colors.green),
                _buildStat('Efficiency', '94%', Icons.trending_up, Color(0xFF915BEE)),
              ],
            ),
          ),
          
          // Production Orders
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getPriorityColor(order['priority']),
                      child: Icon(Icons.factory, color: Colors.white, size: 20),
                    ),
                    title: Text(
                      '${order['garment']} - ${order['customer']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Order #${order['order_id']} • Due: ${order['due_date']}'),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStageColor(order['stage']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order['stage'],
                        style: TextStyle(
                          color: _getStageColor(order['stage']),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Progress
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Production Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('${order['progress']}%', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF915BEE))),
                              ],
                            ),
                            SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: order['progress'] / 100,
                              backgroundColor: Colors.grey[200],
                              color: Color(0xFF915BEE),
                              minHeight: 8,
                            ),
                            SizedBox(height: 16),
                            
                            // Details Grid
                            GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 3,
                              children: [
                                _buildDetailCell('Assigned To', order['assigned_to'], Icons.person),
                                _buildDetailCell('Start Date', order['start_date'], Icons.calendar_today),
                                _buildDetailCell('Due Date', order['due_date'], Icons.event),
                                _buildDetailCell('Priority', order['priority'], Icons.priority_high),
                              ],
                            ),
                            
                            if (order['notes'].isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.note, size: 16, color: Colors.grey[600]),
                                      SizedBox(width: 8),
                                      Expanded(child: Text(order['notes'])),
                                    ],
                                  ),
                                ),
                              ),
                            
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _updateProgress(order),
                                    icon: Icon(Icons.update),
                                    label: Text('Update Progress'),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _moveToNextStage(order),
                                    icon: Icon(Icons.arrow_forward),
                                    label: Text('Next Stage'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF915BEE),
                                    ),
                                  ),
                                ),
                              ],
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

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildDetailCell(String label, String value, IconData icon) {
   