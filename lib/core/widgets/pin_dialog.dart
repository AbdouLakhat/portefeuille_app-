import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Dialog personnalisé pour l'entrée d'un code PIN sécurisé.
/// Retourne le code PIN saisi ou null si annulé.
class PinDialog extends StatefulWidget {
  const PinDialog({super.key});

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  static const int _pinLength = 4;
  static const String _hintText = "••••";

  late final TextEditingController _pinController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  /// Valide le code PIN saisi
  bool _validatePin() {
    if (_pinController.text.isEmpty) {
      _showError("Veuillez entrer un code PIN");
      return false;
    }
    if (_pinController.text.length != _pinLength) {
      _showError("Le code PIN doit contenir $_pinLength chiffres");
      return false;
    }
    return true;
  }

  /// Affiche un message d'erreur
  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  /// Construit la décoration du champ de saisie
  InputDecoration _buildPinFieldDecoration() {
    return InputDecoration(
      hintText: _hintText,
      errorText: _errorMessage,
      prefixIcon: const Icon(Icons.lock, color: AppColors.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  /// Soumet le formulaire après validation
  void _submitPin() {
    if (_validatePin()) {
      Navigator.pop(context, _pinController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Confirmer l'action",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Entrez votre code PIN pour valider",
            style: TextStyle(color: AppColors.textGrey),
          ),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: _pinLength,
            textAlign: TextAlign.center,
            onChanged: (_) => setState(() => _errorMessage = null),
            decoration: _buildPinFieldDecoration(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text(
            "Annuler",
            style: TextStyle(color: AppColors.textGrey),
          ),
        ),
        ElevatedButton(onPressed: _submitPin, child: const Text("Valider")),
      ],
    );
  }
}
