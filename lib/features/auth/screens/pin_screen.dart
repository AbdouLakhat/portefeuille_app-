import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

// Le mode du PIN : connexion ou inscription
enum PinMode { login, register }

class PinScreen extends StatefulWidget {

  final PinMode mode; // On précise le mode à l'ouverture

  const PinScreen({
    super.key,
    this.mode = PinMode.login, // Par défaut c'est la connexion
  });

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {

  String _pin        = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _isLoading    = false;

  void _onKeyPressed(String value) {
    // Mode CONNEXION — on saisit juste 4 chiffres
    if (widget.mode == PinMode.login) {
      if (_pin.length < 4) {
        setState(() => _pin += value);
        if (_pin.length == 4) _verifyLogin();
      }
      return;
    }

    // Mode INSCRIPTION — on saisit puis confirme
    if (!_isConfirming && _pin.length < 4) {
      setState(() => _pin += value);
      if (_pin.length == 4) {
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() => _isConfirming = true);
        });
      }
    } else if (_isConfirming && _confirmPin.length < 4) {
      setState(() => _confirmPin += value);
      if (_confirmPin.length == 4) _verifyRegister();
    }
  }

  void _onDelete() {
    setState(() {
      if (widget.mode == PinMode.login) {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else {
        if (_isConfirming && _confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else if (!_isConfirming && _pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  // Vérification PIN pour la CONNEXION
  void _verifyLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    // Pour l'instant on accepte n'importe quel PIN
    // Plus tard on vérifiera avec les vraies données
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // Vérification PIN pour l'INSCRIPTION
  void _verifyRegister() async {
    if (_pin == _confirmPin) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte créé avec succès !'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les PIN ne correspondent pas, réessayez'),
          backgroundColor: AppColors.error,
        ),
      );
      setState(() {
        _pin        = '';
        _confirmPin = '';
        _isConfirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentPin = _isConfirming ? _confirmPin : _pin;

    // Titre selon le mode
    String titre = widget.mode == PinMode.login
        ? 'Entrez votre PIN'
        : _isConfirming
            ? 'Confirmez votre PIN'
            : 'Créez votre PIN';

    // Sous-titre selon le mode
    String sousTitre = widget.mode == PinMode.login
        ? 'Saisissez votre code à 4 chiffres'
        : _isConfirming
            ? 'Saisissez à nouveau votre PIN'
            : 'Ce code sécurise vos transactions';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: AppSizes.xl),

            // Icône
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: const Icon(
                Icons.lock,
                color: AppColors.white,
                size: 40,
              ),
            ),

            const SizedBox(height: AppSizes.lg),

            // Titre
            Text(
              titre,
              style: const TextStyle(
                fontSize: AppSizes.fontXxl,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: AppSizes.sm),

            // Sous-titre
            Text(
              sousTitre,
              style: const TextStyle(
                fontSize: AppSizes.fontMd,
                color: AppColors.textGrey,
              ),
            ),

            const SizedBox(height: AppSizes.xl),

            // Les 4 cercles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                bool isFilled = index < currentPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isFilled ? AppColors.primary : AppColors.textGrey,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: AppSizes.xl),

            // Clavier
            if (_isLoading)
              const CircularProgressIndicator(color: AppColors.primary)
            else
              _buildKeypad(),

          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
      child: Column(
        children: [
          _buildKeyRow(['1', '2', '3']),
          const SizedBox(height: AppSizes.md),
          _buildKeyRow(['4', '5', '6']),
          const SizedBox(height: AppSizes.md),
          _buildKeyRow(['7', '8', '9']),
          const SizedBox(height: AppSizes.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 80),
              _buildKey('0'),
              _buildDeleteKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKey(key)).toList(),
    );
  }

  Widget _buildKey(String value) {
    return GestureDetector(
      onTap: () => _onKeyPressed(value),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: AppSizes.fontXxl,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return GestureDetector(
      onTap: _onDelete,
      child: const SizedBox(
        width: 80,
        height: 80,
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            color: AppColors.textDark,
            size: 28,
          ),
        ),
      ),
    );
  }
}