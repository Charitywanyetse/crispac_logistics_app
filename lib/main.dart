import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screens/login_screen.dart';
import 'screens/auth_screens/registeration_screen.dart';
import 'screens/auth_screens/forgot_password_screen.dart';
import 'screens/auth_screens/verification_screen.dart';
import 'screens/auth_screens/reset_password_screen.dart';
import 'customer/main_screen.dart';

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
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/verification') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => VerificationScreen(email: args),
          );
        }
        if (settings.name == '/reset-password') {
          // FIXED: Get email from arguments
          final args = settings.arguments as String?;
          if (args == null) {
            // If no email provided, go back to login
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




// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'screens/splash_screen.dart';
// import 'screens/auth_screens/login_screen.dart';
// import 'screens/auth_screens/registeration_screen.dart';
// import 'screens/auth_screens/forgot_password_screen.dart';
// import 'screens/auth_screens/verification_screen.dart';
// import 'screens/auth_screens/reset_password_screen.dart';
// import 'customer/main_screen.dart';
// import 'admin/admin_dashboard.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Crispac Logistics',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Color(0xFF915BEE),
//         primarySwatch: Colors.deepPurple,
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: AppBarTheme(
//           elevation: 0,
//           backgroundColor: Color(0xFF915BEE),
//           foregroundColor: Colors.white,
//           centerTitle: true,
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Color(0xFF915BEE), width: 2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.red, width: 1),
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//         textButtonTheme: TextButtonThemeData(
//           style: TextButton.styleFrom(
//             foregroundColor: Color(0xFF915BEE),
//           ),
//         ),
//       ),
//       home: SplashScreen(),
//       routes: {
//         '/login': (context) => LoginScreen(),
//         '/register': (context) => RegisterationScreen(),
//         '/forgot-password': (context) => ForgotPasswordScreen(),
//         '/verification': (context) => VerificationScreen(email: ''),
//         '/reset-password': (context) => ResetPasswordScreen(),
//         '/customer': (context) => MainScreen(),
//         '/admin': (context) => AdminDashboard(),
//       },
//       onGenerateRoute: (settings) {
//         if (settings.name == '/verification') {
//           final args = settings.arguments as String;
//           return MaterialPageRoute(
//             builder: (context) => VerificationScreen(email: args),
//           );
//         }
//         return null;
//       },
//     );
//   }
// }