import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    // Couleur principale de l'app
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    // Style des boutons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        minimumSize: const Size(double.infinity, 52),
      ),
    ),

    // Style des champs de texte
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: BorderSide.none,
      ),
    ),

    // Style des textes
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: AppSizes.fontXxl,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
      bodyMedium: TextStyle(
        fontSize: AppSizes.fontMd,
        color: AppColors.textGrey,
      ),
    ),
  );
}