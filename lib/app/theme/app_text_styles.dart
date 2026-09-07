import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography configuration for "Decision-Oriented Minimalism" using Inter
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter';

  // Display: 32px, 700 bold, 40px line height, -0.02em letter spacing
  static TextStyle get display => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
        color: AppColors.onSurface,
      );

  // Headline: 28px, 700 bold, 36px line height, -0.01em letter spacing
  static TextStyle get headline => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 36 / 28,
        letterSpacing: -0.01 * 28,
        color: AppColors.onSurface,
      );

  // Section Title: 20px, 600 semi-bold, 28px line height
  static TextStyle get sectionTitle => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.onSurface,
      );

  // Body Large: 16px, 400 regular, 24px line height (1.5x)
  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurface,
      );

  // Body Small: 14px, 400 regular, 20px line height
  static TextStyle get bodySm => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.onSurfaceVariant,
      );

  // Label Bold: 12px, 600 semi-bold, 16px line height, 0.05em letter spacing
  static TextStyle get labelBold => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 0.05 * 12,
        color: AppColors.onSurfaceVariant,
      );

  // Material TextTheme
  static TextTheme get textTheme => TextTheme(
        displayLarge: display,
        headlineLarge: headline,
        headlineMedium: headline.copyWith(fontSize: 24, height: 32 / 24),
        titleLarge: sectionTitle,
        titleMedium: sectionTitle.copyWith(fontSize: 18, height: 24 / 18),
        bodyLarge: bodyLg,
        bodyMedium: bodySm,
        labelLarge: labelBold,
        labelMedium: labelBold.copyWith(fontSize: 11),
      );
}
