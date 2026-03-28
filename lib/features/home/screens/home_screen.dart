import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/pin_dialog.dart';
import '../../../providers/auth_provider.dart';
import '../../transfer/screens/transfer_screen.dart';
import '../../bills/screens/bill_payment_screen.dart';
import '../../qr_code/screens/qr_scanner_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../wallet/screens/deposit_screen.dart';
import '../../history/screens/history_screen.dart';
import '../../../data/models/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
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
        title: const Text(
          'SENPAY',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.fontXl,
          ),
        ),
        actions: [
          // Bouton déconnexion
          IconButton(
            onPressed: () async {
              String? pin = await showDialog(
                context: context,
                builder: (_) => PinDialog(),
              );
              if (pin != null && auth.verifyPin(pin)) {
                auth.logout();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              } else if (pin != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('PIN incorrect'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout, color: AppColors.textDark),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.md),

            // ══════════════════════════
            // CARTE DU SOLDE
            // ══════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.cardGradientStart,
                      AppColors.cardGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour, ${user?.fullName ?? 'Utilisateur'} 👋',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: AppSizes.fontMd,
                      ),
                    ),

                    const SizedBox(height: AppSizes.sm),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isBalanceVisible
                              ? currencyFormatter.format(user?.balance ?? 0)
                              : '•••••• F CFA',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isBalanceVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () => setState(
                            () => _isBalanceVisible = !_isBalanceVisible,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.sm),

                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          '+221 ${user?.phoneNumber ?? ''}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: AppSizes.fontMd,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // ══════════════════════════
            // BOUTONS D'ACTION
            // ══════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.swap_horiz,
                    label: 'Transfert',
                    color: AppColors.primary,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransferScreen(),
                        ),
                      );
                      if (result == true && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transfert réussi ! ✅'),
                            backgroundColor: AppColors.success,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.add_circle_outline,
                    label: 'Dépôt',
                    color: AppColors.success,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DepositScreen()),
                    ),
                  ),
                  _buildActionButton(
                    icon: Icons.receipt_long,
                    label: 'Factures',
                    color: AppColors.warning,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BillPaymentScreen(),
                        ),
                      );
                      if (result == true && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Paiement effectué ! ✅'),
                            backgroundColor: AppColors.success,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.qr_code_scanner,
                    label: 'Scanner',
                    color: AppColors.success,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QrScannerScreen(),
                      ),
                    ),
                  ),
                  _buildActionButton(
                    icon: Icons.person,
                    label: 'Profil',
                    color: AppColors.textGrey,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // ══════════════════════════
            // TRANSACTIONS RÉCENTES
            // ══════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transactions récentes',
                    style: TextStyle(
                      fontSize: AppSizes.fontLg,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    ),
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),

            auth.transactions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text(
                      'Aucune transaction récente',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                    itemCount: auth.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = auth.transactions[index];

                      // ✅ On se base sur le TYPE et non le signe du montant
                      final isNegative =
                          transaction.type == TransactionType.envoi ||
                          transaction.type == TransactionType.facture;

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSizes.sm),
                        padding: const EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Icône
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: isNegative
                                    ? AppColors.error.withOpacity(0.1)
                                    : AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusSm,
                                ),
                              ),
                              child: Icon(
                                isNegative
                                    ? Icons.arrow_outward
                                    : Icons.arrow_downward,
                                color: isNegative
                                    ? AppColors.error
                                    : AppColors.success,
                              ),
                            ),
                            const SizedBox(width: AppSizes.md),
                            // Titre + date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy HH:mm',
                                    ).format(transaction.date),
                                    style: const TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: AppSizes.fontSm,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Montant avec signe
                            Text(
                              '${isNegative ? '-' : '+'} ${currencyFormatter.format(transaction.amount)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isNegative
                                    ? AppColors.error
                                    : AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppSizes.fontSm,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
