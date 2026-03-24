import 'package:flutter/material.dart';

class AppColors {
  // Couleur principale (bleu Wave)
  static const Color primary    = Color(0xFF1F75D8);
  static const Color primaryDark = Color(0xFF1557A0);

  // Couleurs de fond
  static const Color background = Color(0xFFF5F7FA);
  static const Color white      = Color(0xFFFFFFFF);

  // Couleurs des textes
  static const Color textDark   = Color(0xFF1A1A2E);
  static const Color textGrey   = Color(0xFF8A8A8A);

  // Couleurs des statuts
  static const Color success    = Color(0xFF2ECC71); // vert  → dépôt reçu
  static const Color error      = Color(0xFFE74C3C); // rouge → échec
  static const Color warning    = Color(0xFFF39C12); // orange → en cours

  // Couleur de la carte du solde
  static const Color cardGradientStart = Color(0xFF1F75D8);
  static const Color cardGradientEnd   = Color(0xFF0D47A1);
}