import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Compact, pill-shaped label used for filters, categories, and metadata.
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    super.key,
    this.selected = false,
    this.leading,
    this.onSelected,
    this.activeColor = AppColors.primary,
  });

  final String label;
  final bool selected;
  final Widget? leading;
  final ValueChanged<bool>? onSelected;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      avatar: leading,
      backgroundColor: AppColors.surfaceMuted,
      selectedColor: activeColor,
      labelStyle: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: AppColors.textPrimary),
      side: BorderSide.none,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
    );
  }
}

enum AppBadgeTone { neutral, primary, urgent, warning, completed, ai }

/// Non-interactive semantic badge for task priority, status, and AI labels.
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    super.key,
    this.tone = AppBadgeTone.neutral,
    this.leading,
  });

  final String label;
  final AppBadgeTone tone;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(tone);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppRadius.chip,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: colors.foreground),
            ),
          ],
        ),
      ),
    );
  }

  _BadgeColors _colorsFor(AppBadgeTone value) => switch (value) {
    AppBadgeTone.neutral => const _BadgeColors(
      AppColors.surfaceMuted,
      AppColors.textSecondary,
    ),
    AppBadgeTone.primary => const _BadgeColors(
      AppColors.primarySoft,
      AppColors.textPrimary,
    ),
    AppBadgeTone.urgent => const _BadgeColors(
      AppColors.urgentSoft,
      AppColors.urgent,
    ),
    AppBadgeTone.warning => const _BadgeColors(
      AppColors.warningSoft,
      AppColors.warning,
    ),
    AppBadgeTone.completed => const _BadgeColors(
      AppColors.completedSoft,
      AppColors.completed,
    ),
    AppBadgeTone.ai => const _BadgeColors(AppColors.aiSoft, AppColors.aiPurple),
  };
}

class _BadgeColors {
  const _BadgeColors(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
