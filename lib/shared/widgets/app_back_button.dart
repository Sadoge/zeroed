import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';

/// Circular back button used across detail/create screens.
///
/// bgCard background, 40x40, cornerRadius: 20, arrow-left icon
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: AppSizing.iconButtonSize,
        height: AppSizing.iconButtonSize,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.iconButtonBorder,
        ),
        child: Center(
          child: Icon(
            LucideIcons.arrowLeft,
            size: AppSizing.iconMd,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
