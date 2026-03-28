import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/pin_dialog.dart';
import '../../../providers/auth_provider.dart';

class ConfirmTransferScreen extends StatefulWidget {
  final String recipient;
  final String nom;
  final String prenom;
  final double amount;

  const ConfirmTransferScreen({
    super.key,
    required this.recipient,
    required this.nom,
    required this.prenom,
    required this.amount,
  });

  @override
  State<ConfirmTransferScreen> createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen> {
  bool _isLoading = false;

  void _confirm() async {
    final screenContext = context;

    // Demander le PIN
    String? pin = await showDialog<String>(
      context: screenContext,
      builder: (_) => PinDialog(),
    );

    if (pin == null || pin.isEmpty) return;

    final auth = Provider.of<AuthProvider>(screenContext, listen: false);

    if (!auth.verifyPin(pin)) {
      ScaffoldMessenger.of(screenContext).showSnackBar(
        const SnackBar(
          content: Text('Code PIN incorrect ❌'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    bool success = auth.transferMoney(widget.recipient, widget.amount);

    if (!mounted) return;

    if (success) {
      Navigator.pop(screenContext, true);
    } else {
      ScaffoldMessenger.of(screenContext).showSnackBar(
        const SnackBar(
          content: Text('Solde insuffisant ❌'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'F CFA',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Text(
          'Confirmation',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.lg),

            // Icône envoi
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: const Icon(Icons.send, size: 40, color: AppColors.primary),
            ),

            const SizedBox(height: AppSizes.lg),

            const Text(
              'Confirmer le transfert',
              style: TextStyle(
                fontSize: AppSizes.fontXxl,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: AppSizes.sm),

            const Text(
              'Vérifiez les détails avant de confirmer',
              style: TextStyle(
                fontSize: AppSizes.fontMd,
                color: AppColors.textGrey,
              ),
            ),

            const SizedBox(height: AppSizes.xl),

            // Récapitulatif
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Column(
                children: [
                  // Nom complet
                  _buildDetailRow(
                    icon: Icons.person,
                    label: 'Destinataire',
                    value: '${widget.prenom} ${widget.nom}',
                  ),

                  const Divider(height: AppSizes.xl),

                  // Numéro de téléphone
                  _buildDetailRow(
                    icon: Icons.phone,
                    label: 'Numéro de téléphone',
                    value: '+221 ${widget.recipient}',
                  ),

                  const Divider(height: AppSizes.xl),

                  _buildDetailRow(
                    icon: Icons.money,
                    label: 'Montant',
                    value: currencyFormatter.format(widget.amount),
                    valueColor: AppColors.primary,
                    valueBold: true,
                  ),

                  const Divider(height: AppSizes.xl),

                  _buildDetailRow(
                    icon: Icons.account_balance_wallet,
                    label: 'Solde actuel',
                    value: currencyFormatter.format(
                      auth.currentUser?.balance ?? 0,
                    ),
                  ),

                  const Divider(height: AppSizes.xl),

                  _buildDetailRow(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Solde après transfert',
                    value: currencyFormatter.format(
                      (auth.currentUser?.balance ?? 0) - widget.amount,
                    ),
                    valueColor: AppColors.error,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.xl),

            // Bouton confirmer
            ElevatedButton(
              onPressed: _isLoading ? null : _confirm,
              child: _isLoading
                  ? const CircularProgressIndicator(color: AppColors.white)
                  : const Text(
                      'Confirmer et envoyer',
                      style: TextStyle(
                        fontSize: AppSizes.fontLg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            const SizedBox(height: AppSizes.sm),

            // Bouton annuler
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Annuler',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: AppSizes.fontLg,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: AppSizes.fontMd,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textDark,
            fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
            fontSize: AppSizes.fontMd,
          ),
        ),
      ],
    );
  }
}
