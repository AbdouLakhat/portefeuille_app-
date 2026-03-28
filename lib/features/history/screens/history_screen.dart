import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../providers/auth_provider.dart';
import '../../../data/models/transaction_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Filtre sélectionné (null = tout afficher)
  TransactionType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'F CFA',
      decimalDigits: 0,
    );

    // Filtrer les transactions
    final transactions = _selectedFilter == null
        ? auth.transactions
        : auth.transactions.where((t) => t.type == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Text(
          'Historique',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // ══════════════════════════
          // FILTRES
          // ══════════════════════════
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Filtre Tout
                  _buildFilterChip(
                    label: 'Tout',
                    isSelected: _selectedFilter == null,
                    color: AppColors.primary,
                    onTap: () => setState(() => _selectedFilter = null),
                  ),

                  const SizedBox(width: AppSizes.sm),

                  // Filtre Envois
                  _buildFilterChip(
                    label: 'Envois',
                    isSelected: _selectedFilter == TransactionType.envoi,
                    color: AppColors.error,
                    onTap: () =>
                        setState(() => _selectedFilter = TransactionType.envoi),
                  ),

                  const SizedBox(width: AppSizes.sm),

                  // Filtre Réceptions
                  _buildFilterChip(
                    label: 'Réceptions',
                    isSelected: _selectedFilter == TransactionType.reception,
                    color: AppColors.success,
                    onTap: () => setState(
                      () => _selectedFilter = TransactionType.reception,
                    ),
                  ),

                  const SizedBox(width: AppSizes.sm),

                  // Filtre Factures
                  _buildFilterChip(
                    label: 'Factures',
                    isSelected: _selectedFilter == TransactionType.facture,
                    color: AppColors.warning,
                    onTap: () => setState(
                      () => _selectedFilter = TransactionType.facture,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          // ══════════════════════════
          // LISTE DES TRANSACTIONS
          // ══════════════════════════
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: AppColors.textGrey.withOpacity(0.3),
                        ),
                        const SizedBox(height: AppSizes.md),
                        const Text(
                          'Aucune transaction',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: AppSizes.fontLg,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return _buildTransactionItem(
                        transaction,
                        currencyFormatter,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget filtre
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: isSelected ? color : AppColors.textGrey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textGrey,
            fontWeight: FontWeight.w600,
            fontSize: AppSizes.fontSm,
          ),
        ),
      ),
    );
  }

  // Widget une transaction
  Widget _buildTransactionItem(
    TransactionModel transaction,
    NumberFormat formatter,
  ) {
    // ✅ On se base sur le TYPE
    final isNegative =
        transaction.type == TransactionType.envoi ||
        transaction.type == TransactionType.facture;

    IconData icon;
    Color color;

    switch (transaction.type) {
      case TransactionType.envoi:
        icon = Icons.arrow_outward;
        color = AppColors.error;
        break;
      case TransactionType.reception:
        icon = Icons.arrow_downward;
        color = AppColors.success;
        break;
      case TransactionType.facture:
        icon = Icons.receipt_long;
        color = AppColors.warning;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        children: [
          // Icône
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(icon, color: color),
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
                const SizedBox(height: AppSizes.xs),
                Text(
                  DateFormat(
                    'dd MMM yyyy à HH:mm',
                    'fr_FR',
                  ).format(transaction.date),
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: AppSizes.fontSm,
                  ),
                ),
              ],
            ),
          ),
          // Montant
          Text(
            '${isNegative ? '-' : '+'} ${formatter.format(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isNegative ? AppColors.error : AppColors.success,
              fontSize: AppSizes.fontMd,
            ),
          ),
        ],
      ),
    );
  }
}
