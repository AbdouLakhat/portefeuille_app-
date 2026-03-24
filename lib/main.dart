import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';

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

      // Les routes de l'app (les chemins vers chaque écran)
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const Scaffold(
          body: Center(child: Text('Login — bientôt !')),
        ),
      },
    );
  }
}