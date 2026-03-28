import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/pin_dialog.dart';
import '../../../providers/auth_provider.dart';

// Les services disponibles
class ServiceItem {
  final String name;
  final IconData icon;
  final Color color;

  ServiceItem({required this.name, required this.icon, required this.color});
}

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  String _searchQuery = '';

  // Liste des services
  final List<ServiceItem> _services = [
    ServiceItem(name: 'SENELEC', icon: Icons.bolt, color: Colors.orange),
    ServiceItem(name: "SEN'EAU", icon: Icons.water_drop, color: Colors.blue),
    ServiceItem(name: 'RAPIDO', icon: Icons.local_taxi, color: Colors.red),
    ServiceItem(
      name: 'WOYOFAL',
      icon: Icons.electric_bolt,
      color: Colors.yellow.shade700,
    ),
    ServiceItem(name: 'CANAL+', icon: Icons.tv, color: Colors.black87),
    ServiceItem(name: 'EXPRESSO', icon: Icons.wifi, color: Colors.purple),
  ];

  // Afficher le formulaire de paiement
  void _showBillDialog(ServiceItem service) {
    final referenceController = TextEditingController();
    final amountController = TextEditingController();

    // ✅ On sauvegarde le contexte de l'écran Bills AVANT d'ouvrir les dialogs
    final screenContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Paiement ${service.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: referenceController,
              decoration: InputDecoration(
                labelText: 'Numéro de client / Compteur',
                prefixIcon: const Icon(Icons.numbers, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Montant (F CFA)',
                prefixIcon: const Icon(Icons.money, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.textGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (referenceController.text.isNotEmpty &&
                  amountController.text.isNotEmpty) {
                // Fermer le dialog du formulaire
                Navigator.pop(dialogContext);

                // Demander le PIN avec le contexte de l'écran
                String? pin = await showDialog<String>(
                  context: screenContext,
                  builder: (_) => PinDialog(),
                );

                if (pin == null || pin.isEmpty) return;

                final auth = Provider.of<AuthProvider>(
                  screenContext,
                  listen: false,
                );

                if (auth.verifyPin(pin)) {
                  bool success = auth.payBill(
                    service.name,
                    referenceController.text,
                    double.parse(amountController.text),
                  );

                  if (success) {
                    // ✅ On ferme l'écran Bills avec true
                    Navigator.pop(screenContext, true);
                  } else {
                    ScaffoldMessenger.of(screenContext).showSnackBar(
                      const SnackBar(
                        content: Text('Solde insuffisant ❌'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(screenContext).showSnackBar(
                    const SnackBar(
                      content: Text('Code PIN incorrect ❌'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Payer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer selon la recherche
    final filtered = _services
        .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Text(
          'Paiement de factures',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Rechercher un service...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
            ),
          ),

          // Liste des services
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final service = filtered[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSizes.sm),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: service.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Icon(service.icon, color: service.color),
                    ),
                    title: Text(
                      service.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    subtitle: const Text(
                      'Paiement immédiat sans frais',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textGrey,
                    ),
                    onTap: () => _showBillDialog(service),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
