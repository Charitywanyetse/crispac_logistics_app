import 'package:flutter/material.dart';

class CustomersManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers Management'),
        backgroundColor: Color(0xFF915BEE),
      ),
      body: Center(
        child: Text('Customers Management Screen'),
      ),
    );
  }
}