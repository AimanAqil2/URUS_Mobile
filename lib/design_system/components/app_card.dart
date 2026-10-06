import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_shadows.dart';
import '../tokens/app_spacing.dart';

/// White, softly elevated container used for URUS content groups.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.color,
    this.borderRadius = AppRadius.card,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Ink(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: borderRadius,
        boxShadow: AppShadows.card,
      ),
      child: Padding(padding: padding, child: child),
    );

    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: onTap == null
            ? content
            : InkWell(onTap: onTap, borderRadius: borderRadius, child: content),
      ),
    );
  }
}
