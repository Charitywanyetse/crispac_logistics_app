import 'package:crispac_logistics/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // adjust import path

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'crispac logistics',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // <-- Start here
    );
  }
}



// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'screens/dashboard/dashboard_screen.dart';
// import 'providers/dashboard_provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Crispac Logistics',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: ChangeNotifierProvider(
//         create: (_) => DashboardProvider()..loadDashboardData(),
//         child: DashboardScreen(),
//       ),
//     );
//   }
// }

















// import 'package:flutter/material.dart';
// import 'screens/splash_screen.dart';
// import 'screens/main_screen.dart';
// import 'screens/auth screens/login_screen.dart'; 

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Crispac Logistics',
//       theme: ThemeData(primarySwatch: Colors.deepPurple),
//       // Start with SplashScreen
//       home: SplashScreen(),
//       routes: {
//         '/login': (_) => LoginScreen(),
//         '/main': (_) => MainScreen(),
//       },
//     );
//   }
// }
