import 'package:flutter/material.dart';
import 'home_screen.dart';
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: PageView(
          controller: _controller,
          onPageChanged: (index) => setState(() => isLastPage = index == 3),
          children: [
            buildPage(
              image: '',
              title: 'Uniforms for Schools',
              description: 'Professional and comfortable uniforms for students and teachers.',
            ),
            buildPage(
              image: 'assets/hotel.jpg',
              title: 'Hotel & Restaurant Staff',
              description: 'Smart and stylish uniforms for chefs, waiters, and receptionists.',
            ),
            buildPage(
              image: 'assets/industrial.jpg',
              title: 'Industrial & Construction',
              description: 'Safe and durable work uniforms for construction and industrial teams.',
            ),
            buildPage(
              image: 'assets/med.png',
              title: 'Medical Professionals',
              description: 'Clean and professional scrubs and lab coats for hospitals and clinics.',
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()), // goes to Auth first
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                color: Colors.deepPurple,
                alignment: Alignment.center,
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          : Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('Skip'),
                    onPressed: () => _controller.jumpToPage(3),
                  ),
                  Row(
                    children: [
                      TextButton(
                        child: const Text('Next'),
                        onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildPage({
    required String image,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 300), // Illustration
        const SizedBox(height: 30),
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
