import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
    _checkIfUserKnown();
  }

  Future<void> _checkIfUserKnown() async {
    // On regarde si un numéro est sauvegardé sur CE téléphone
    final prefs = await SharedPreferences.getInstance();
    final telephone = prefs.getString('user_telephone');

    if (!mounted) return;

    if (telephone != null) {
      // ✅ Téléphone connu → directement vers le PIN
      Navigator.pushReplacementNamed(context, '/pin');
    } else {
      // ❌ Nouveau téléphone → on demande le numéro
      Navigator.pushReplacementNamed(context, '/login-telephone');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Écran de chargement pendant la vérification
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}