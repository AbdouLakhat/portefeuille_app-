import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/pin_dialog.dart';
import '../../../providers/auth_provider.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {

  final _amountController = TextEditingController();
  bool _isLoading = false;

  // Montants rapides prédéfinis
  final List<int> _quickAmounts = [5000, 10000, 25000, 50000, 100000, 200000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _deposit() async {
    final amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrez un montant valide'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Demander le PIN
    String? pin = await showDialog(
      context: context,
      builder: (_) => PinDialog(),
    );

    if (pin == null) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (auth.verifyPin(pin)) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isLoading = false);

      auth.deposit(amount);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dépôt de ${amount.toStringAsFixed(0)} F CFA effectué ! ✅'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code PIN incorrect'),
            backgroundColor: AppColors.error,
          ),
        );
      }
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
          'Dépôt d\'argent',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: AppSizes.md),

            // Illustration
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 45,
                  color: AppColors.success,
                ),
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // Champ montant
            const Text(
              'Montant à déposer',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: AppSizes.fontXxl,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: '0',
                suffixText: 'F CFA',
                prefixIcon: const Icon(Icons.money, color: AppColors.success),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // Montants rapides
            const Text(
              'Montants rapides',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: _quickAmounts.map((amount) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _amountController.text = amount.toString();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${amount ~/ 1000}k F CFA',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSizes.xl),

            // Bouton déposer
            ElevatedButton(
              onPressed: _isLoading ? null : _deposit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: AppColors.white)
                  : const Text(
                      'Déposer',
                      style: TextStyle(
                        fontSize: AppSizes.fontLg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

          ],
        ),
      ),
    );
  }
}