import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/main_screen.dart';
import 'screens/auth screens/login_screen.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crispac Logistics',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      // Start with SplashScreen
      home: SplashScreen(),
      routes: {
        '/login': (_) => LoginScreen(),
        '/main': (_) => MainScreen(),
      },
    );
  }
}
