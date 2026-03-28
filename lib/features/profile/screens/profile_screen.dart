import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController    = TextEditingController();
  final _oldPinController  = TextEditingController();
  final _newPinController  = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      _nameController.text = user.fullName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _oldPinController.dispose();
    _newPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    if (user == null) return const SizedBox();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: const Text(
          'Mon Profil',
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

            const SizedBox(height: AppSizes.md),

            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: const Icon(
                Icons.person,
                size: 50,
                color: AppColors.white,
              ),
            ),

            const SizedBox(height: AppSizes.sm),

            Text(
              user.fullName,
              style: const TextStyle(
                fontSize: AppSizes.fontXl,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            Text(
              '+221 ${user.phoneNumber}',
              style: const TextStyle(
                color: AppColors.textGrey,
                fontSize: AppSizes.fontMd,
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // ══════════════════════════
            // SECTION INFORMATIONS
            // ══════════════════════════
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Informations',
                        style: TextStyle(
                          fontSize: AppSizes.fontLg,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isEditing ? Icons.check : Icons.edit,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          if (_isEditing) {
                            auth.updateUserInfo(_nameController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profil mis à jour ✅'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                          setState(() => _isEditing = !_isEditing);
                        },
                      ),
                    ],
                  ),

                  const Divider(),

                  // Nom complet
                  TextField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: const InputDecoration(
                      labelText: 'Nom complet',
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                    ),
                  ),

                  const SizedBox(height: AppSizes.sm),

                  // Téléphone (non modifiable)
                  TextField(
                    controller: TextEditingController(text: user.phoneNumber),
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                    ),
                  ),

                  const SizedBox(height: AppSizes.sm),

                  // CNI (non modifiable)
                  TextField(
                    controller: TextEditingController(text: user.idNumber),
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Numéro CNI",
                      prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primary),
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: AppSizes.md),

            // ══════════════════════════
            // SECTION SÉCURITÉ
            // ══════════════════════════
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Sécurité',
                    style: TextStyle(
                      fontSize: AppSizes.fontLg,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  const Divider(),

                  const Text(
                    'Changer le code PIN',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: AppSizes.sm),

                  // Ancien PIN
                  TextField(
                    controller: _oldPinController,
                    obscureText: true,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ancien PIN',
                      prefixIcon: Icon(Icons.lock_open, color: AppColors.primary),
                    ),
                  ),

                  const SizedBox(height: AppSizes.sm),

                  // Nouveau PIN
                  TextField(
                    controller: _newPinController,
                    obscureText: true,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Nouveau PIN',
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                    ),
                  ),

                  const SizedBox(height: AppSizes.md),

                  // Bouton mettre à jour
                  ElevatedButton(
                    onPressed: () {
                      if (_oldPinController.text.length == 4 &&
                          _newPinController.text.length == 4) {
                        bool success = auth.changePin(
                          _oldPinController.text,
                          _newPinController.text,
                        );
                        if (success) {
                          _oldPinController.clear();
                          _newPinController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('PIN modifié avec succès ! ✅'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ancien PIN incorrect'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Le PIN doit faire 4 chiffres'),
                            backgroundColor: AppColors.warning,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Mettre à jour le PIN',
                      style: TextStyle(
                        fontSize: AppSizes.fontLg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}