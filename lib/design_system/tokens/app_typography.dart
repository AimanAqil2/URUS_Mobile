import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Poppins type ramp matched to the compact, rounded Stitch interface.
abstract final class AppTypography {
  static TextTheme get textTheme {
    final base = GoogleFonts.poppinsTextTheme();

    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 16,
        height: 1.4,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
        fontSize: 14,
        height: 1.4,
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: .15,
      ),
      labelMedium: base.labelMedium?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: .25,
      ),
    );
  }
}
