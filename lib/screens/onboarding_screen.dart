import 'package:flutter/material.dart';

import 'auth screens/login_screen.dart';



class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) => setState(() => isLastPage = index == 3),
        children: [
          buildPage('assets/school.png', 'School Uniforms',
              'Neat and smart uniforms for students and teachers.'),
          buildPage('assets/hotel.png', 'Hotel & Restaurant',
              'Professional uniforms for chefs and service staff.'),
          buildPage('assets/Construction Wear.png', 'Construction & Industry',
              'Durable uniforms for industrial and field workers.'),
          buildPage('assets/med.png', 'Medical Professionals',
              'Clean and professional uniforms for hospitals.'),
        ],
      ),
      bottomSheet: isLastPage
          ? TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                color: const Color.fromARGB(255, 173, 139, 233),
                alignment: Alignment.center,
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          : Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('Skip'),
                    onPressed: () => _controller.jumpToPage(3),
                  ),
                  TextButton(
                    child: const Text('Next'),
                    onPressed: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildPage(String image, String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 180),
          const SizedBox(height: 25),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
