import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';

/// Floating action button with accent glow.
///
/// Matches design component: FAB (c0y4p)
class AppFab extends StatelessWidget {
  const AppFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizing.fabSize,
      height: AppSizing.fabSize,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: AppRadius.fabBorder,
        boxShadow: const [
          BoxShadow(
            color: Color(0x4022D3EE),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.fabBorder,
          child: Center(
            child: Icon(
              LucideIcons.plus,
              size: AppSizing.iconLg,
              color: AppColors.textInverted,
            ),
          ),
        ),
      ),
    );
  }
}
