import 'package:flutter/material.dart';
import 'auth_screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding data matching the exact style from images
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'CRISPAC',
      'subtitle': 'Hotel & Restaurant',
      'description': 'Professional uniforms for chefs',
      'fullDescription': 'Professional uniforms for chefs and service staff.',
      'icon': Icons.restaurant,
      'step': '01',
    },
    {
      'title': 'CRISPAC',
      'subtitle': 'Medical Professionals',
      'description': 'Clean and professional uniforms',
      'fullDescription': 'Clean and professional uniforms for hospitals and clinics.',
      'icon': Icons.medical_services,
      'step': '02',
    },
    {
      'title': 'CRISPAC',
      'subtitle': 'Corporate & Business',
      'description': 'Elegant professional attire',
      'fullDescription': 'Sophisticated uniforms for corporate environments and business settings.',
      'icon': Icons.business_center,
      'step': '03',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    
    if (mounted) {
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
            // Subtle noise texture overlay
            IgnorePointer(
              child: Opacity(
                opacity: 0.05,
                child: Image.network(
                  'https://www.transparenttextures.com/patterns/black-scales.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
            ),
            
            // Ambient glow effect
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.5 - 150,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF506EA0).withOpacity(0.12),
                      Color(0xFF14192D).withOpacity(0.0),
                    ],
                    stops: [0.0, 0.7],
                  ),
                ),
              ),
            ),
            
            SafeArea(
              child: Column(
                children: [
                  // Skip Button - Top Right Corner
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Color(0xFFA3B3D6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Page View
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _onboardingData.length,
                      itemBuilder: (context, index) {
                        return _buildOnboardingPage(index);
                      },
                    ),
                  ),
                  
                  // Bottom Section
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: Column(
                      children: [
                        // Step indicator (STEP XX / XX)
                        Text(
                          'STEP ${_onboardingData[_currentPage]['step'].toString().padLeft(2, '0')} / ${_onboardingData.length.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                            color: Color(0xFF6C7A9E),
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Page Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _onboardingData.length,
                            (index) => AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: _currentPage == index ? 28 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white24,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        // Next Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_currentPage == _onboardingData.length - 1) {
                                _completeOnboarding();
                              } else {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1A1C23),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _currentPage == _onboardingData.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(int index) {
    final data = _onboardingData[index];
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Icon Container - circular white background
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.85, end: 1.0),
              duration: Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 25,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  data['icon'],
                  size: 65,
                  color: Color(0xFF1A1C23),
                ),
              ),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
            ),
            SizedBox(height: 48),
            
            // Title: CRISPAC (brand name with gradient)
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
                data['title'],
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 12),
            
            // Subtitle (e.g., Hotel & Restaurant)
            Text(
              data['subtitle'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            
            // Description line (first line - matches image exactly)
            Text(
              data['description'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFC9D4ED),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Full description (second line - extra detail)
            if (data['fullDescription'] != data['description'])
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  data['fullDescription'].replaceFirst(data['description'], '').trim(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8A99B8),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}