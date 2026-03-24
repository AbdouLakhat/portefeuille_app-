import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/pin_screen.dart';
import 'features/auth/screens/login_telephone_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portefeuille App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/':        (context) => const SplashScreen(),
        '/login':   (context) => const LoginScreen(),
        '/register':(context) => const RegisterScreen(),

        // PIN connexion
        '/pin':     (context) => const PinScreen(mode: PinMode.login),

        // PIN inscription
        '/pin-register': (context) => const PinScreen(mode: PinMode.register),
        '/login-telephone': (context) => const LoginTelephoneScreen(),

        '/home':    (context) => const Scaffold(
          body: Center(child: Text('Dashboard — bientôt !')),
        ),
      },
    );
  }
}