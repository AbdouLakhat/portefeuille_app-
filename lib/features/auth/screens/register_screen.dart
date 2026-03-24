import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    if (_nomController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_phoneController.text.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Numéro de téléphone invalide'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Simule un chargement
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    // Redirige vers la création du PIN
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/pin-register');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Créer un compte ',
                style: TextStyle(
                  fontSize: AppSizes.fontXxl,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: AppSizes.sm),

              const Text(
                'Rejoignez MonPortefeuille en quelques secondes',
                style: TextStyle(
                  fontSize: AppSizes.fontMd,
                  color: AppColors.textGrey,
                ),
              ),

              const SizedBox(height: AppSizes.xl),

              // Champ Nom
              _buildLabel('Nom'),
              const SizedBox(height: AppSizes.sm),
              TextField(
                controller: _nomController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'votre nom ici ...',
                  prefixIcon: Icon(Icons.person, color: AppColors.primary),
                ),
              ),

              const SizedBox(height: AppSizes.md),

              // Champ Prénom
              _buildLabel('Prénom'),
              const SizedBox(height: AppSizes.sm),
              TextField(
                controller: _prenomController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'votre prénom ici ...',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.md),

              // Champ Téléphone
              _buildLabel('Numéro de téléphone'),
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

              // Bouton continuer
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
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

              // Lien retour login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Déjà un compte ? ',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Se connecter',
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }
}
