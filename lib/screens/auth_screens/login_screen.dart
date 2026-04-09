import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registeration_screen.dart';
import 'forgot_password_screen.dart';
import 'package:crispac_logistics/screens/home_screen.dart';

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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'demo_token');
    await prefs.setString('user_email', _emailController.text.trim());
    await prefs.setString('user_name', 'Alexander');
    await prefs.setBool('remember_me', _rememberMe);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }

    setState(() => _isLoading = false);
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
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // Google Sign In
                                    _showSnackBar("Google Sign In coming soon");
                                  },
                                  icon: Image.network(
                                    'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                    height: 20,
                                    width: 20,
                                    errorBuilder: (context, error, stackTrace) => 
                                      Icon(Icons.g_mobiledata, size: 20),
                                  ),
                                  label: Text("Google"),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: Colors.grey[300]!),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // Apple Sign In
                                    _showSnackBar("Apple Sign In coming soon");
                                  },
                                  icon: Icon(Icons.apple, size: 20),
                                  label: Text("Apple"),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(color: Colors.grey[300]!),
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'registeration_screen.dart';
// import 'forgot_password_screen.dart';
// import 'package:crispac_logistics/screens/home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _isLoading = false;
//   bool _obscurePassword = true;

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     // Simulate API call
//     await Future.delayed(Duration(seconds: 2));

//     // Save login state
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', 'demo_token');
//     await prefs.setString('user_email', _emailController.text.trim());
//     await prefs.setString('user_name', 'Alexander');

//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => HomeScreen()),
//       );
//     }

//     setState(() => _isLoading = false);
//   }

//   Route _animatedRoute(Widget page) {
//     return PageRouteBuilder(
//       transitionDuration: const Duration(milliseconds: 500),
//       pageBuilder: (_, animation, secondaryAnimation) => page,
//       transitionsBuilder: (_, animation, __, child) {
//         final offsetAnimation = Tween(
//           begin: const Offset(1.0, 0.0),
//           end: Offset.zero,
//         ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutQuad));
//         return SlideTransition(position: offsetAnimation, child: child);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF3EEF9),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(20),
//             child: Container(
//               padding: EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 20,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // Logo
//                     Container(
//                       padding: EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: Color(0xFFF3EEF9),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Image.asset(
//                         "assets/logo.png",
//                         height: 30,
//                         errorBuilder: (context, error, stackTrace) => Icon(
//                           Icons.local_shipping,
//                           size: 30,
//                           color: Color(0xFF8E2DE2),
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 20),

//                     Text(
//                       "Welcome Back",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1A1C23),
//                       ),
//                     ),

//                     SizedBox(height: 6),

//                     Text(
//                       "Please login to your Crispac account",
//                       style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                     ),

//                     SizedBox(height: 30),

//                     // EMAIL field with icon
//                     _inputField(
//                       controller: _emailController,
//                       hint: "Enter your email",
//                       icon: Icons.email_outlined,
//                       keyboardType: TextInputType.emailAddress,
//                     ),

//                     SizedBox(height: 16),

//                     // PASSWORD field with icon
//                     _inputField(
//                       controller: _passwordController,
//                       hint: "Enter your password",
//                       icon: Icons.lock_outline,
//                       isPassword: true,
//                     ),

//                     SizedBox(height: 12),

//                     // Forgot Password - WITH NAVIGATION
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             _animatedRoute(ForgotPasswordScreen()),
//                           );
//                         },
//                         child: Text(
//                           "Forgot Password?",
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Color(0xFF8E2DE2),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 24),

//                     // SIGN IN BUTTON
//                     _isLoading
//                         ? Center(
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8E2DE2)),
//                             ),
//                           )
//                         : SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: _login,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Color(0xFF8E2DE2),
//                                 foregroundColor: Colors.white,
//                                 padding: EdgeInsets.symmetric(vertical: 14),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               child: Text(
//                                 "Sign In",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),

//                     SizedBox(height: 24),

//                     // OR divider
//                     Row(
//                       children: [
//                         Expanded(child: Divider(color: Colors.grey[300])),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 12),
//                           child: Text(
//                             "Or continue with",
//                             style: TextStyle(color: Colors.grey[500], fontSize: 12),
//                           ),
//                         ),
//                         Expanded(child: Divider(color: Colors.grey[300])),
//                       ],
//                     ),

//                     SizedBox(height: 16),

//                     // Social buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         _socialBtn("Google", Icons.g_mobiledata),
//                         SizedBox(width: 12),
//                         _socialBtn("Apple", Icons.apple),
//                       ],
//                     ),

//                     SizedBox(height: 24),

//                     // Sign Up link
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Don't have an account? ",
//                           style: TextStyle(color: Colors.grey[600], fontSize: 13),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               _animatedRoute(RegisterationScreen()),
//                             );
//                           },
//                           child: Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               color: Color(0xFF8E2DE2),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
                    
//                     SizedBox(height: 8),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _inputField({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     bool isPassword = false,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword ? _obscurePassword : false,
//       keyboardType: keyboardType,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "This field is required";
//         }
//         if (!isPassword && !value.contains('@')) {
//           return "Enter a valid email";
//         }
//         if (isPassword && value.length < 6) {
//           return "Password must be at least 6 characters";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
//         prefixIcon: Icon(icon, color: Color(0xFF8E2DE2), size: 20),
//         suffixIcon: isPassword
//             ? IconButton(
//                 icon: Icon(
//                   _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                   color: Colors.grey[500],
//                   size: 20,
//                 ),
//                 onPressed: () {
//                   setState(() => _obscurePassword = !_obscurePassword);
//                 },
//               )
//             : null,
//         filled: true,
//         fillColor: Color(0xFFF3EEF9),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Color(0xFF8E2DE2), width: 1.5),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   Widget _socialBtn(String text, IconData icon) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       decoration: BoxDecoration(
//         color: Color(0xFFF3EEF9),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 18, color: Colors.grey[700]),
//           SizedBox(width: 8),
//           Text(
//             text,
//             style: TextStyle(color: Colors.grey[700], fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }
// }