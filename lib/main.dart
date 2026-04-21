import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screens/login_screen.dart';
import 'screens/auth_screens/registeration_screen.dart';
import 'screens/auth_screens/forgot_password_screen.dart';
import 'screens/auth_screens/verification_screen.dart';
import 'screens/auth_screens/reset_password_screen.dart';
import 'customer/main_screen.dart';
import 'screens/dashboard_screen.dart'; // Keep this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crispac Logistics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF915BEE),
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF915BEE),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterationScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/customer': (context) => MainScreen(),
        '/dashboard': (context) => AdminDashboardScreen(), // Dashboard route
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/verification') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => VerificationScreen(email: args),
          );
        }
        if (settings.name == '/reset-password') {
          final args = settings.arguments as String?;
          if (args == null) {
            return MaterialPageRoute(
              builder: (context) => LoginScreen(),
            );
          }
          return MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: args),
          );
        }
        return null;
      },
    );
  }
}