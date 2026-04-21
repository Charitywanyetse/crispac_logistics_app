import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'registeration_screen.dart';
import 'package:http/http.dart' as http;
import 'forgot_password_screen.dart';
import 'package:crispac_logistics/screens/home_screen.dart';
import 'package:crispac_logistics/screens/dashboard_screen.dart';
import 'package:crispac_logistics/services/api_services.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  final ApiService _apiService = ApiService();

  // Real app store URLs
  final String _googlePlayStoreUrl = 'https://play.google.com/store/apps/details?id=com.crispac.logistics';
  final String _appleAppStoreUrl = 'https://apps.apple.com/app/id1234567890';

  Future<void> _login() async {
    print('========== LOGIN ATTEMPT ==========');
    print('Email: ${_emailController.text}');
    
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    print('Form validation passed');
    setState(() => _isLoading = true);

    print('Calling API login...');
    final result = await _apiService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    print('API Result success: ${result['success']}');
    print('API Result data: ${result['data']}');
    
    setState(() => _isLoading = false);

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', _rememberMe);
      
      final isAdmin = prefs.getBool('is_admin') ?? false;
      final userRole = prefs.getString('user_role') ?? 'customer';
      
      print('=== USER DATA FROM STORAGE ===');
      print('is_admin from prefs: $isAdmin');
      print('user_role from prefs: $userRole');
      print('user_email from prefs: ${prefs.getString('user_email')}');
      print('================================');
      
      if (isAdmin || userRole == 'admin') {
        print('✅ NAVIGATING TO ADMIN DASHBOARD');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardScreen()),
          );
        }
      } else {
        print('✅ NAVIGATING TO CUSTOMER HOME');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        }
      }
    } else {
      print('❌ Login failed: ${result['message']}');
      _showSnackBar(result['message'], isError: true);
    }
  }

  // Debug method to check stored credentials
  Future<void> _checkStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    print('===== STORED CREDENTIALS =====');
    print('Token: ${prefs.getString('token')}');
    print('is_admin: ${prefs.getBool('is_admin')}');
    print('user_role: ${prefs.getString('user_role')}');
    print('user_email: ${prefs.getString('user_email')}');
    print('user_name: ${prefs.getString('user_name')}');
    print('==============================');
    
    _showSnackBar('Check terminal for stored credentials');
  }

  Future<void> _launchGooglePlayStore() async {
    final Uri url = Uri.parse(_googlePlayStoreUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar("Could not open Google Play Store");
      }
    } catch (e) {
      _showSnackBar("Error opening store: $e");
    }
  }

  Future<void> _launchAppleAppStore() async {
    final Uri url = Uri.parse(_appleAppStoreUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar("Could not open Apple App Store");
      }
    } catch (e) {
      _showSnackBar("Error opening store: $e");
    }
  }

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutQuad));
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top decorative shape
                Container(
                  height: 200,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: -30,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Center(
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
                                size: 50,
                                color: Color(0xFF8E2DE2),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'CRISPAC',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Logistics',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Login Form Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1C23),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Sign in to continue to your account",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 32),

                          // Email Field
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F9FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: 16),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email is required";
                                }
                                if (!value.contains('@')) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF8E2DE2)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color(0xFFF8F9FF),
                                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Password Field
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F9FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(fontSize: 16),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password is required";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF8E2DE2)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey[500],
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color(0xFFF8F9FF),
                                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),

                          // Remember Me & Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                    activeColor: Color(0xFF8E2DE2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Text(
                                    "Remember Me",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    _animatedRoute(ForgotPasswordScreen()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF8E2DE2),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),

                          // Debug Button - Check Stored Credentials
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _checkStoredCredentials,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(color: Colors.orange),
                                ),
                              ),
                              child: Text(
                                "Debug: Check Storage",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),

                          // Sign In Button
                          _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8E2DE2)),
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF8E2DE2),
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                          
                          SizedBox(height: 24),

                          // OR Divider
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey[300])),
                            ],
                          ),
                          SizedBox(height: 24),

                          // Social Login Buttons
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _launchGooglePlayStore,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                          height: 20,
                                          width: 20,
                                          errorBuilder: (context, error, stackTrace) => 
                                            Icon(Icons.g_mobiledata, size: 20),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Google",
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: _launchAppleAppStore,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.apple, size: 20, color: Colors.grey[700]),
                                        SizedBox(width: 8),
                                        Text(
                                          "Apple",
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),

                          // Sign Up Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    _animatedRoute(RegisterationScreen()),
                                  );
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8E2DE2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}