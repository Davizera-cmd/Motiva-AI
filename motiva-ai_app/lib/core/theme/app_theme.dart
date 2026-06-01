import 'package:flutter/material.dart';
import 'package:motiva_ai/core/constants/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3:            true,
    scaffoldBackgroundColor: AppColors.motivBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor:   AppColors.motivYellow,
      brightness:  Brightness.light,
      primary:     AppColors.motivYellow,
      onPrimary:   AppColors.motivTextBlack,
      secondary:   AppColors.motivYellowDark,
      onSecondary: AppColors.white,
      surface:     AppColors.white,
      onSurface:   AppColors.motivTextBlack,
      error:       AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.motivYellow,
      foregroundColor: AppColors.motivTextBlack,
      elevation:       2,
      centerTitle:     false,
      titleTextStyle:  TextStyle(
        fontSize:   20,
        fontWeight: FontWeight.bold,
        color:      AppColors.motivTextBlack,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.motivYellow,
        foregroundColor: AppColors.motivTextBlack,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        elevation: 3,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled:    true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.motivYellowDark, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      color:     AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
    ),
  );
}
