import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class FinanceScreen extends StatefulWidget {
  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'This Year'];
  
  // Mock data - replace with API calls
  final Map<String, dynamic> _financialData = {
    'revenue': 2450000,
    'expenses': 890000,
    'profit': 1560000,
    'pending_payments': 320000,
    'overdue_payments': 45000,
    'transactions': [
      {'date': '2024-03-25', 'description': 'Order #ORD-1001', 'amount': 45000, 'type': 'income'},
      {'date': '2024-03-25', 'description': 'Fabric Purchase', 'amount': 120000, 'type': 'expense'},
      {'date': '2024-03-24', 'description': 'Order #ORD-1002', 'amount': 38000, 'type': 'income'},
      {'date': '2024-03-24', 'description': 'Threads & Accessories', 'amount': 25000, 'type': 'expense'},
      {'date': '2024-03-23', 'description': 'Order #ORD-1003', 'amount': 145000, 'type': 'income'},
      {'date': '2024-03-23', 'description': 'Equipment Maintenance', 'amount': 50000, 'type': 'expense'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Finance Management'),
        backgroundColor: Color(0xFF915BEE),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: _periods.map((period) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPeriod = period;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedPeriod == period ? Color(0xFF915BEE) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          period,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _selectedPeriod == period ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),

            // Summary Cards
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildSummaryCard(
                  'Revenue',
                  'UGX ${NumberFormat('#,###').format(_financialData['revenue'])}',
                  Icons.trending_up,
                  Colors.green,
                  '+23%',
                ),
                _buildSummaryCard(
                  'Expenses',
                  'UGX ${NumberFormat('#,###').format(_financialData['expenses'])}',
                  Icons.trending_down,
                  Colors.red,
                  '+5%',
                ),
                _buildSummaryCard(
                  'Net Profit',
                  'UGX ${NumberFormat('#,###').format(_financialData['profit'])}',
                  Icons.attach_money,
                  Color(0xFF915BEE),
                  '+18%',
                ),
                _buildSummaryCard(
                  'Pending',
                  'UGX ${NumberFormat('#,###').format(_financialData['pending_payments'])}',
                  Icons.pending,
                  Colors.orange,
                  '3 orders',
                ),
              ],
            ),
            SizedBox(height: 24),

            // Revenue Chart
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Revenue Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 1.2),
                              FlSpot(1, 1.8),
                              FlSpot(2, 2.5),
                              FlSpot(3, 2.3),
                              FlSpot(4, 3.0),
                              FlSpot(5, 3.8),
                              FlSpot(6, 4.2),
                            ],
                            isCurved: true,
                            color: Color(0xFF915BEE),
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Income vs Expenses Pie Chart
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Income vs Expenses',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 150,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: _financialData['revenue'].toDouble(),
                                  title: 'Income',
                                  color: Colors.green,
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  value: _financialData['expenses'].toDouble(),
                                  title: 'Expenses',
                                  color: Colors.red,
                                  radius: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLegend('Income', Colors.green),
                            SizedBox(width: 16),
                            _buildLegend('Expenses', Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Stats',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12),
                        _buildQuickStat('Profit Margin', '64%', Icons.percent),
                        _buildQuickStat('Avg. Order Value', 'UGX 45,000', Icons.shopping_bag),
                        _buildQuickStat('Monthly Growth', '+18%', Icons.trending_up),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Recent Transactions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('View All'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _financialData['transactions'].length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      final transaction = _financialData['transactions'][index];
                      final isIncome = transaction['type'] == 'income';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          child: Icon(
                            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                            color: isIncome ? Colors.green : Colors.red,
                            size: 20,
                          ),
                        ),
                        title: Text(transaction['description']),
                        subtitle: Text(transaction['date']),
                        trailing: Text(
                          '${isIncome ? '+' : '-'} UGX ${NumberFormat('#,###').format(transaction['amount'])}',
                          style: TextStyle(
                            color: isIncome ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, String trend) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Color(0xFF915BEE)),
          SizedBox(width: 8),
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 12)),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}