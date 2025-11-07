import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
@override
_SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
void initState() {
super.initState();

// Move to Onboarding after 3 seconds
Timer(Duration(seconds: 3), () {
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) => OnboardingScreen()),
);
});

}



@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.deepPurple,
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
// App logo or icon
Image.asset('assets/logo.png', height: 200),
SizedBox(height: 25),
Text(
"welcome to Crispac logistics App",
style: TextStyle(
color: const Color.fromARGB(255, 233, 230, 235),
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 40),
CircularProgressIndicator(color: const Color.fromARGB(255, 14, 13, 13)),
],
),
),
);
}
}