



import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dart:async';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  // OTP Controllers
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());
  
  bool _isLoading = false;
  bool _showOtpField = true;
  bool _showPasswordField = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String _passwordStrength = '';
  bool _canResend = false;
  int _secondsRemaining = 59;
  Timer? _timer;
  
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
    
    _newPasswordController.addListener(_checkPasswordStrength);
    _startResendTimer();
    
    // Auto-focus first OTP field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNodes[0].requestFocus();
    });
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _secondsRemaining = 59;
    });

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _checkPasswordStrength() {
    String password = _newPasswordController.text;
    setState(() {
      if (password.isEmpty) {
        _passwordStrength = '';
      } else if (password.length < 6) {
        _passwordStrength = 'Weak';
      } else if (password.length >= 6 && password.length < 10) {
        _passwordStrength = 'Moderate';
      } else {
        _passwordStrength = 'Strong';
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    _newPasswordController.removeListener(_checkPasswordStrength);
    super.dispose();
  }

  String _getOtp() {
    return _otpControllers.map((c) => c.text).join();
  }

  void _verifyOtp() {
    String otp = _getOtp();
    if (otp.length < 6) {
      _showErrorSnackBar("Please enter the complete 6-digit verification code");
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API verification
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _showOtpField = false;
        _showPasswordField = true;
      });
      
      _showSuccessSnackBar("Code verified! Please create a new password.");
    });
  }

  void _resendCode() {
    if (!_canResend) return;
    
    _startResendTimer();
    
    // Clear existing OTP
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _otpFocusNodes[0].requestFocus();
    
    _showSuccessSnackBar("Verification code resent to ${widget.email}");
  }

  void _updatePassword() {
    String newPass = _newPasswordController.text.trim();
    String confirmPass = _confirmPasswordController.text.trim();

    if (newPass.isEmpty) {
      _showErrorSnackBar("Please enter a new password");
      return;
    }

    if (newPass.length < 6) {
      _showErrorSnackBar("Password must be at least 6 characters");
      return;
    }

    if (newPass != confirmPass) {
      _showErrorSnackBar("Passwords do not match");
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      
      _showSuccessSnackBar("Password reset successfully!");
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Back Button
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                    
                    // Header Section
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
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
                              _showOtpField ? Icons.security_outlined : Icons.lock_reset_outlined,
                              size: 50,
                              color: Color(0xFF8E2DE2),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            _showOtpField ? "Verify Account" : "Reset Password",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            _showOtpField 
                              ? "Enter the 6-digit verification code sent to your email"
                              : "Create a new, strong password to secure your account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                          if (_showOtpField) ...[
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.email,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Form Container
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _showOtpField
                            ? _buildOtpSection()
                            : _buildPasswordSection(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOtpSection() {
    return [
      Text(
        "Verification Code",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1C23),
        ),
      ),
      SizedBox(height: 8),
      Text(
        "Please enter the 6-digit code we sent to your email",
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      SizedBox(height: 32),
      
      // 6-Digit OTP Fields
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) {
          return Container(
            width: 50,
            height: 60,
            child: TextFormField(
              controller: _otpControllers[index],
              focusNode: _otpFocusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1C23),
              ),
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: Color(0xFFF8F9FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF8E2DE2), width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
              onChanged: (value) {
                if (value.length == 1 && index < 5) {
                  _otpFocusNodes[index + 1].requestFocus();
                } else if (value.isEmpty && index > 0) {
                  _otpFocusNodes[index - 1].requestFocus();
                }
              },
            ),
          );
        }),
      ),
      
      SizedBox(height: 32),
      
      // Verify Button
      _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8E2DE2)),
              ),
            )
          : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8E2DE2),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Verify Code",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
      SizedBox(height: 24),
      
      // Resend Code Section
      Column(
        children: [
          Text(
            "Resend Code",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _canResend ? Color(0xFF8E2DE2) : Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8),
          if (!_canResend)
            Text(
              'Wait ${_secondsRemaining.toString().padLeft(2, '0')} to resend',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          if (_canResend)
            TextButton(
              onPressed: _resendCode,
              child: Text(
                'Tap to resend code',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8E2DE2),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
      
      SizedBox(height: 16),
      
      // Divider
      Container(
        height: 1,
        color: Colors.grey.shade200,
        margin: EdgeInsets.symmetric(vertical: 16),
      ),
      
      // Check your Inbox Section
      Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.mark_email_read_outlined,
              size: 32,
              color: Colors.grey[500],
            ),
            SizedBox(height: 8),
            Text(
              'Check your Inbox',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Check again if you don\'t see it in a minute.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildPasswordSection() {
    return [
      Text(
        "Create New Password",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1C23),
        ),
      ),
      SizedBox(height: 8),
      Text(
        "Your new password must be different from previous ones",
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      SizedBox(height: 32),
      
      // New Password Field
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Password",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: "Enter your new password",
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF8E2DE2)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[500],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
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
          if (_passwordStrength.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _passwordStrength == 'Strong' 
                          ? Colors.green 
                          : (_passwordStrength == 'Moderate' 
                              ? Colors.orange 
                              : Colors.red),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Password Strength: $_passwordStrength',
                    style: TextStyle(
                      fontSize: 12,
                      color: _passwordStrength == 'Strong' 
                          ? Colors.green 
                          : (_passwordStrength == 'Moderate' 
                              ? Colors.orange 
                              : Colors.red),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      
      SizedBox(height: 20),
      
      // Confirm Password Field
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Confirm Password",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: "Confirm your new password",
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.lock_reset_outlined, color: Color(0xFF8E2DE2)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[500],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
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
        ],
      ),
      
      SizedBox(height: 32),
      
      // Update Password Button
      _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8E2DE2)),
              ),
            )
          : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8E2DE2),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
      SizedBox(height: 24),
      
      // Back to Login Link
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Remember your password? ",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              "Back to Login",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8E2DE2),
              ),
            ),
          ),
        ],
      ),
      
      SizedBox(height: 24),
      
      // Footer
      Column(
        children: [
          Text(
            '© 2026 CRISPAC LOGISTICS',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PRIVACY',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'TERMS',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    ];
  }
}


// import 'package:flutter/material.dart';
// import 'login_screen.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   final String email;
  
//   const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

//   @override
//   _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscureNewPassword = true;
//   bool _obscureConfirmPassword = true;
//   String _passwordStrength = '';
  
//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//     _slideAnimation =
//         Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
//     );
//     _controller.forward();
    
//     _newPasswordController.addListener(_checkPasswordStrength);
//   }

//   void _checkPasswordStrength() {
//     String password = _newPasswordController.text;
//     setState(() {
//       if (password.isEmpty) {
//         _passwordStrength = '';
//       } else if (password.length < 6) {
//         _passwordStrength = 'Weak';
//       } else if (password.length >= 6 && password.length < 10) {
//         _passwordStrength = 'Moderate';
//       } else {
//         _passwordStrength = 'Strong';
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     _newPasswordController.removeListener(_checkPasswordStrength);
//     super.dispose();
//   }

//   void _updatePassword() {
//     String newPass = _newPasswordController.text.trim();
//     String confirmPass = _confirmPasswordController.text.trim();

//     if (newPass.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a new password'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     if (newPass.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Password must be at least 6 characters'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     if (newPass != confirmPass) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Passwords do not match'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     Future.delayed(Duration(seconds: 2), () {
//       setState(() => _isLoading = false);
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Password reset successfully!'),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );

//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => LoginScreen()),
//         (route) => false,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF6B48FF),
//               Color(0xFF915BEE),
//               Color(0xFFB27AFF),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Back to Login Button
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       style: TextButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.arrow_back_ios, size: 16),
//                           SizedBox(width: 4),
//                           Text(
//                             'Back to Login',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
                  
//                   SizedBox(height: 40),
                  
//                   // Lock Icon
//                   Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 20,
//                           offset: Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       Icons.lock_reset_outlined,
//                       size: 50,
//                       color: Color(0xFF915BEE),
//                     ),
//                   ),
                  
//                   SizedBox(height: 24),
                  
//                   // Title
//                   Text(
//                     'Reset Password',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
                  
//                   SizedBox(height: 12),
                  
//                   // Description
//                   Text(
//                     'Create a new, strong password to secure your account.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white70,
//                       height: 1.4,
//                     ),
//                   ),
                  
//                   SizedBox(height: 40),
                  
//                   // New Password Field
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'New Password',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 8,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _newPasswordController,
//                           obscureText: _obscureNewPassword,
//                           style: TextStyle(color: Color(0xFF1A1C23)),
//                           decoration: InputDecoration(
//                             hintText: 'Enter your new password',
//                             hintStyle: TextStyle(color: Colors.grey[400]),
//                             prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF915BEE)),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
//                                 color: Colors.grey,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscureNewPassword = !_obscureNewPassword;
//                                 });
//                               },
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide.none,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                           ),
//                         ),
//                       ),
//                       if (_passwordStrength.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8, left: 12),
//                           child: Text(
//                             'Strong: $_passwordStrength',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: _passwordStrength == 'Strong' 
//                                   ? Colors.green[300] 
//                                   : (_passwordStrength == 'Moderate' 
//                                       ? Colors.orange[300] 
//                                       : Colors.red[300]),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
                  
//                   SizedBox(height: 20),
                  
//                   // Confirm New Password Field
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Confirm New Password',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 8,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _confirmPasswordController,
//                           obscureText: _obscureConfirmPassword,
//                           style: TextStyle(color: Color(0xFF1A1C23)),
//                           decoration: InputDecoration(
//                             hintText: 'Confirm your new password',
//                             hintStyle: TextStyle(color: Colors.grey[400]),
//                             prefixIcon: const Icon(Icons.lock_reset_outlined, color: Color(0xFF915BEE)),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
//                                 color: Colors.grey,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscureConfirmPassword = !_obscureConfirmPassword;
//                                 });
//                               },
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide.none,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   SizedBox(height: 30),
                  
//                   // Update Password Button
//                   _isLoading
//                       ? Center(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: _updatePassword,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               foregroundColor: Color(0xFF915BEE),
//                               minimumSize: const Size(double.infinity, 52),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: Text(
//                               'Update Password',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF915BEE),
//                               ),
//                             ),
//                           ),
//                         ),
                  
//                   SizedBox(height: 30),
                  
//                   // Footer
//                   Column(
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Back to Login',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.white70,
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         '© 2026 CRISPAC LOGISTICS',
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: Colors.white54,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'PRIVACY',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.white54,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Text(
//                             'TERMS',
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.white54,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
                  
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }