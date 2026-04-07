import 'package:flutter/material.dart';

class ProductsManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products Management'),
        backgroundColor: Color(0xFF915BEE),
      ),
      body: Center(
        child: Text('Products Management Screen'),
      ),
    );
  }
}