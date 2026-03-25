import 'package:crispac_logistics/screens/Dashboard/DashboardScreen.dart';
import 'package:flutter/material.dart';
import '../screens/Dashboard/DashboardScreen.dart'; // adjust path
// import 'home_screen.dart';
import 'orders_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'products_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

final List<Widget> _screens = [
  DashboardScreen(),
  OrdersScreen(),
  ProductsScreen(),
  NotificationsScreen(),
  ProfileScreen(),
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.local_shipping),
      label: 'Orders',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_bag),
      label: 'Products',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Notifications',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
),

    );
  }
}
