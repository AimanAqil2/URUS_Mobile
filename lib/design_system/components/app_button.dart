import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

enum AppButtonVariant { primary, ai, neutral, danger }

/// Rounded action button with the visual treatments used throughout URUS.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expand = true,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expand;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(variant);
    final style = FilledButton.styleFrom(
      minimumSize: Size(0, height),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      backgroundColor: colors.background,
      foregroundColor: colors.foreground,
      disabledBackgroundColor: colors.background.withValues(alpha: .45),
      disabledForegroundColor: colors.foreground.withValues(alpha: .55),
      textStyle: Theme.of(context).textTheme.labelLarge,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.field),
    );
    final Widget child = icon == null
        ? FilledButton(onPressed: onPressed, style: style, child: Text(label))
        : FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 20),
            label: Text(label),
            style: style,
          );

    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }

  _ButtonColors _colorsFor(AppButtonVariant value) => switch (value) {
    AppButtonVariant.primary => const _ButtonColors(
      AppColors.primary,
      AppColors.textPrimary,
    ),
    AppButtonVariant.ai => const _ButtonColors(
      AppColors.aiPurple,
      Colors.white,
    ),
    AppButtonVariant.neutral => const _ButtonColors(
      AppColors.surfaceMuted,
      AppColors.textPrimary,
    ),
    AppButtonVariant.danger => const _ButtonColors(
      AppColors.urgentSoft,
      AppColors.urgent,
    ),
  };
}

class _ButtonColors {
  const _ButtonColors(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
