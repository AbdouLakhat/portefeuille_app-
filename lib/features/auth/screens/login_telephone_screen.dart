import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class LoginTelephoneScreen extends StatefulWidget {
  const LoginTelephoneScreen({super.key});

  @override
  State<LoginTelephoneScreen> createState() => _LoginTelephoneScreenState();
}

class _LoginTelephoneScreenState extends State<LoginTelephoneScreen> {

  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  void _continuer() async {
    if (_phoneController.text.isEmpty || _phoneController.text.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrez un numéro valide'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    // On va vers le PIN avec le numéro en paramètre
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/pin',
        arguments: _phoneController.text, // on passe le numéro au PIN
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: AppSizes.xl),

              // Logo
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.white,
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              const Center(
                child: Text(
                  'Bienvenue dans MonPortefeuille',
                  style: TextStyle(
                    fontSize: AppSizes.fontXxl,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.sm),

              const Center(
                child: Text(
                  'Entrez votre numéro pour continuer',
                  style: TextStyle(
                    fontSize: AppSizes.fontMd,
                    color: AppColors.textGrey,
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.xl),

              const Text(
                'Numéro de téléphone',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '77 123 45 67',
                  prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                ),
              ),

              const SizedBox(height: AppSizes.xl),

              ElevatedButton(
                onPressed: _isLoading ? null : _continuer,
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : const Text(
                        'Continuer',
                        style: TextStyle(
                          fontSize: AppSizes.fontLg,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              const SizedBox(height: AppSizes.md),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pas encore de compte ? ',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      "S'inscrire",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}