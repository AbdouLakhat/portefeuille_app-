import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'confirm_transfer_screen.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // On va vers l'écran de confirmation avec toutes les infos
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmTransferScreen(
          recipient: _recipientController.text,
          nom: _nomController.text,
          prenom: _prenomController.text,
          amount: double.parse(_amountController.text),
        ),
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Text(
          "Envoyer de l'argent",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.md),

              // Prénom
              const Text(
                'Prénom du destinataire',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              TextFormField(
                controller: _prenomController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'votre prénom ici ...',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Prénom requis' : null,
              ),

              const SizedBox(height: AppSizes.md),

              // Nom
              const Text(
                'Nom du destinataire',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              TextFormField(
                controller: _nomController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'votre nom ici ...',
                  prefixIcon: Icon(Icons.person, color: AppColors.primary),
                ),
                validator: (v) => v!.isEmpty ? 'Nom requis' : null,
              ),

              const SizedBox(height: AppSizes.md),

              // Numéro
              const Text(
                'Numéro du destinataire',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              TextFormField(
                controller: _recipientController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '77 123 45 67',
                  prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                  prefixText: '+221 ',
                ),
                validator: (v) => v!.length < 9 ? 'Numéro invalide' : null,
              ),

              const SizedBox(height: AppSizes.md),

              // Montant
              const Text(
                'Montant (F CFA)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ex: 5000',
                  prefixIcon: Icon(Icons.money, color: AppColors.primary),
                ),
                validator: (v) =>
                    (double.tryParse(v!) ?? 0) <= 0 ? 'Montant invalide' : null,
              ),

              const SizedBox(height: AppSizes.xl),

              ElevatedButton(
                onPressed: _submit,
                child: const Text(
                  'Continuer',
                  style: TextStyle(
                    fontSize: AppSizes.fontLg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
