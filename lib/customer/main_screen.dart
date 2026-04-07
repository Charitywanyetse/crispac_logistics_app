import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRISPAC Logistics'),
        backgroundColor: Color(0xFF915BEE),
      ),
      body: Center(
        child: Text(
          'Customer Main Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}