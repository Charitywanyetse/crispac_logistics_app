import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth screens/login_screen.dart';
import 'screens/auth screens/registeration_screen.dart';
import 'screens/auth screens/forgot_password_screen.dart';
import 'screens/auth screens/verification_screen.dart';
import 'screens/auth screens/reset_password_screen.dart';
import 'screens/main_screen.dart';
import 'admin/screens/dashboard_home_screen.dart';

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
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF915BEE),
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
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
            borderSide: BorderSide(color: Color(0xFF915BEE), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF915BEE),
          ),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/verification': (context) => VerificationScreen(email: ''),
        '/reset-password': (context) => ResetPasswordScreen(),
        '/customer': (context) => MainScreen(),
        '/customer-home': (context) => HomeScreen(),
        '/customer-profile': (context) => ProfileScreen(),
        '/customer-settings': (context) => SettingsScreen(),
        '/customer-products': (context) => ProductsScreen(),
        '/customer-create-order': (context) => CreateOrderScreen(),
        '/customer-delivery-history': (context) => DeliveryHistoryScreen(),
        '/customer-support': (context) => SupportContactScreen(),
        '/admin': (context) => AdminDashboard(),
      },
      onGenerateRoute: (settings) {
        // Handle routes with parameters
        if (settings.name == '/verification') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => VerificationScreen(email: args),
          );
        }
        return null;
      },
    );
  }
}