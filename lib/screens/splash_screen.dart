import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'auth_screens/login_screen.dart';
import '../customer/main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkLoginStatus();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      ),
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));
    
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    final token = prefs.getString('token');
    
    if (!hasSeenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    } else if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.2, 0.3),
            radius: 1.2,
            colors: [
              Color(0xFF101215),
              Color(0xFF08090C),
              Color(0xFF030405),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Subtle noise/grain texture overlay
            IgnorePointer(
              child: Opacity(
                opacity: 0.08,
                child: Image.network(
                  'https://www.transparenttextures.com/patterns/black-scales.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
            ),
            
            // Ambient glow effect behind brand
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5 - 150,
              left: MediaQuery.of(context).size.width * 0.5 - 150,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF506EA0).withOpacity(0.15),
                      Color(0xFF14192D).withOpacity(0.0),
                    ],
                    stops: [0.0, 0.7],
                  ),
                ),
              ),
            ),
            
            // Fluid light reflection animation
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        _fadeAnimation.value * 8,
                        _fadeAnimation.value * 4,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(0.3, 0.4),
                            radius: 1.5,
                            colors: [
                              Color(0xFFC8D2FA).withOpacity(0.03),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Main content
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Brand name - CRISPAC with gradient text
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFFE0E4F0),
                              Color(0xFFB9C1D4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            'CRISPAC',
                            style: TextStyle(
                              fontSize: clampValue(52, 80, MediaQuery.of(context).size.width),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 12),
                        
                        // Subtitle - CRISPAC LOGISTICS
                        Text(
                          'CRISPAC LOGISTICS',
                          style: TextStyle(
                            fontSize: clampValue(12, 16, MediaQuery.of(context).size.width),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 3.2,
                            color: Color(0xFFA3B3D6),
                          ),
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Elegant divider
                        Container(
                          width: clampValue(50, 70, MediaQuery.of(context).size.width),
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xFF7F8FAF),
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        
                        SizedBox(height: 28),
                        
                        // Tagline text
                        Column(
                          children: [
                            Text(
                              'Precision logistics for the global retailer.',
                              style: TextStyle(
                                fontSize: clampValue(14, 18, MediaQuery.of(context).size.width),
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFC9D4ED),
                                height: 1.45,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Fast, fluid, and tailor-made.',
                              style: TextStyle(
                                fontSize: clampValue(14, 18, MediaQuery.of(context).size.width),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.45,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // EXIT button - bottom right corner (decorative, non-interactive)
            Positioned(
              bottom: 28,
              right: 24,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF0A0C12).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  'EXIT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.96,
                    color: Color(0xFF6C7A9E),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  double clampValue(double min, double max, double screenWidth) {
    if (screenWidth < 400) return min;
    if (screenWidth > 800) return max;
    return min + (max - min) * ((screenWidth - 400) / 400);
  }
}


// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'onboarding_screen.dart';
// import 'auth_screens/login_screen.dart';
// import '../customer/main_screen.dart';
// import '../admin/admin_dashboard.dart';
// import 'main_screen.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     await Future.delayed(Duration(seconds: 2));
    
//     final prefs = await SharedPreferences.getInstance();
//     final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
//     final token = prefs.getString('token');
    
//     if (!hasSeenOnboarding) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => OnboardingScreen()),
//       );
//     } else if (token != null) {
//       final userRole = prefs.getString('user_role') ?? 'customer';
      
//       if (userRole == 'admin') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => AdminDashboard()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => MainScreen()),
//         );
//       }
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LoginScreen()),
//       );
//     }
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
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.local_shipping,
//                   size: 80,
//                   color: Color(0xFF915BEE),
//                 ),
//               ),
//               SizedBox(height: 32),
//               Text(
//                 'CRISPAC Logistics',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 40),
//               CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }