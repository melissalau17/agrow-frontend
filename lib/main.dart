import 'package:flutter/material.dart';
import 'screens/WelcomePage.dart';
import 'screens/LoginPage.dart';
import 'screens/RegisterPage.dart';
import 'screens/OTPVerificationPage.dart';
import 'screens/SuccessPage.dart';
import 'screens/DashboardPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aGrow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/otp': (context) => const OtpVerificationPage(),
        '/success': (context) => const SuccessPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
