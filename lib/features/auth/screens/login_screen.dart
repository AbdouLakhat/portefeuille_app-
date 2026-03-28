import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// Écran de vérification du statut de l'utilisateur.
/// - Si l'utilisateur existe → redirection vers l'écran PIN
/// - Si nouveau → redirection vers l'écran d'enregistrement du numéro
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const String _userTelephoneKey = 'user_telephone';
  static const String _pinRoute = '/pin';
  static const String _loginTelephoneRoute = '/login-telephone';
  static const int _minDelayMs = 500; // Délai minimum pour UX fluide

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  /// Initialise l'authentification et redirige l'utilisateur
  Future<void> _initializeAuth() async {
    try {
      // Délai minimum pour un meilleur UX et éviter les flashs
      await Future.delayed(const Duration(milliseconds: _minDelayMs));

      if (!mounted) return;

      final isUserKnown = await _isUserKnown();
      _navigateToAppropriateScreen(isUserKnown);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Vérifie si l'utilisateur est connu (numéro sauvegardé)
  Future<bool> _isUserKnown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final telephone = prefs.getString(_userTelephoneKey);
      return telephone != null && telephone.isNotEmpty;
    } catch (e) {
      debugPrint('Erreur lors de la vérification utilisateur: $e');
      return false;
    }
  }

  /// Redirige vers l'écran approprié
  void _navigateToAppropriateScreen(bool isUserKnown) {
    if (!mounted) return;

    final route = isUserKnown ? _pinRoute : _loginTelephoneRoute;
    Navigator.pushReplacementNamed(context, route);
  }

  /// Gère les erreurs lors de l'initialisation
  void _handleError(Object error) {
    debugPrint('Erreur lors de l\'initialisation: $error');
    if (!mounted) return;

    // En cas d'erreur, redirection vers l'écran d'enregistrement
    Navigator.pushReplacementNamed(context, _loginTelephoneRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Vérification en cours...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
