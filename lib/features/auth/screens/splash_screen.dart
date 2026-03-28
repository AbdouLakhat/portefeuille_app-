import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirectAfterDelay();
  }

  // Attend 3 secondes puis va vers le login
  Future<void> _redirectAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fond dégradé bleu
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône / Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // Nom de l'app
              const Text(
                'SENPAY',
                style: TextStyle(
                  fontSize: AppSizes.fontXxl,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),

              const SizedBox(height: AppSizes.sm),

              // Slogan
              const Text(
                'Envoyez, recevez, payez facilement',
                style: TextStyle(
                  fontSize: AppSizes.fontMd,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: AppSizes.xl),

              // Indicateur de chargement
              const CircularProgressIndicator(color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }
}
