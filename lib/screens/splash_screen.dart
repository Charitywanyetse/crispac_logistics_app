import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_screens/login_screen.dart';
import '../customer/main_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));
    
    final prefs = await SharedPreferences.getInstance();
    
    // TEMPORARY: Clear saved data to force login screen
    // Remove these lines after testing
    await prefs.remove('is_logged_in');
    await prefs.remove('token');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_role');
    await prefs.remove('is_admin');
    
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final userEmail = prefs.getString('user_email') ?? '';
    
    // Check if user is admin (you can customize this condition)
    bool isAdmin = userEmail == 'crispac2@gmail.com' || 
                   userEmail == 'admin@crispac.com' ||
                   prefs.getBool('is_admin') == true;
    
    if (mounted) {
      if (isAdmin) {
        // Navigate to Admin Dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (isLoggedIn) {
        // Navigate to Customer Main Screen
        Navigator.pushReplacementNamed(context, '/customer');
      } else {
        // Navigate to Login Screen
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B48FF),
              Color(0xFF8E2DE2),
              Color(0xFFB27AFF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_shipping,
                  size: 60,
                  color: Color(0xFF8E2DE2),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'CRISPAC',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Logistics',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}