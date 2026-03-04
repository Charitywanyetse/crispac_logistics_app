// lib/widgets/dashboard/chart_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartWidget extends StatelessWidget {
  final List<dynamic> monthlySales;

  const ChartWidget({
    Key? key,
    required this.monthlySales,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Color(0xFF9B7BFF),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '\$${rod.toY.toStringAsFixed(0)}',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                  int index = value.toInt();
                  if (index >= 0 && index < months.length) {
                    return Text(
                      months[index],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: _getInterval(),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }

  double _getMaxY() {
    if (monthlySales.isEmpty) return 1000;
    
    double max = 0;
    for (var sale in monthlySales) {
      double value = (sale['total_sales'] ?? 0).toDouble();
      if (value > max) max = value;
    }
    return max * 1.2;
  }

  double _getInterval() {
    double max = _getMaxY();
    if (max <= 1000) return 200;
    if (max <= 5000) return 1000;
    return 2000;
  }

  List<BarChartGroupData> _buildBarGroups() {
    if (monthlySales.isEmpty) {
      return List.generate(6, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: 0,
              color: Color(0xFF9B7BFF).withOpacity(0.3),
              width: 16,
            ),
          ],
        );
      });
    }

    return monthlySales.asMap().entries.map((entry) {
      int index = entry.key;
      var sale = entry.value;
      double value = (sale['total_sales'] ?? 0).toDouble();
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: Color(0xFF9B7BFF),
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}