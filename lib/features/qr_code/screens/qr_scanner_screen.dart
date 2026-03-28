import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../providers/auth_provider.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    // Simule une détection après 2 secondes
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isScanning = false);
        _showPaymentConfirmation();
      }
    });
  }

  void _showPaymentConfirmation() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: const Icon(
                Icons.store,
                size: 35,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: AppSizes.md),

            const Text(
              'BOULANGERIE JAUNE',
              style: TextStyle(
                fontSize: AppSizes.fontXl,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: AppSizes.sm),

            const Text(
              'Montant : 2 500 F CFA',
              style: TextStyle(
                fontSize: AppSizes.fontLg,
                color: AppColors.textGrey,
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // Bouton confirmer
            ElevatedButton(
              onPressed: () {
                final auth = Provider.of<AuthProvider>(context, listen: false);
                bool success = auth.payByQRCode('Boulangerie Jaune', 2500);

                Navigator.pop(context); // Ferme le BottomSheet

                if (success) {
                  Navigator.pop(context); // Retour au Dashboard
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Paiement effectué avec succès ! ✅'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Solde insuffisant'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              child: const Text(
                'CONFIRMER LE PAIEMENT',
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
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          // Viseur de la caméra
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white, width: 2),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: _isScanning
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 80,
                    ),
            ),
          ),

          // Bouton fermer
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: AppColors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Texte en bas
          const Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Text(
              'Placez le QR Code dans le cadre',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppSizes.fontLg,
              ),
            ),
          ),

        ],
      ),
    );
  }
}