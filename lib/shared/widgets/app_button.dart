import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';

/// Button variants derived from design/zeroed.pen.
///
/// **Primary:** accent fill, inverted text, h52, r12
///   → Preview Invoice, Send Invoice, Continue, Download CSV
///
/// **Secondary:** bgCard fill, border stroke, white text, h48, r12
///   → Edit, Download PDF, Mark as Paid
///
/// **Danger:** statusOverdue fill, inverted text, h52, r12
///   → Send Reminder
///
/// **Ghost:** no fill, border stroke, tertiary text, h44, r10
///   → Add Line Item
enum AppButtonVariant { primary, secondary, danger, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.color,
    this.isLoading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;

  /// Override the fill color (e.g. Stripe purple `#635BFF`).
  final Color? color;
  final bool isLoading;

  /// If true (default), button takes full width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final config = _resolveConfig();

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: expand ? double.infinity : null,
        height: config.height,
        padding: expand
            ? null
            : const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: color ?? config.fill,
          borderRadius: BorderRadius.circular(config.radius),
          border: config.borderColor != null
              ? Border.all(color: config.borderColor!)
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: AppSizing.iconMd,
                  height: AppSizing.iconMd,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: config.foreground,
                  ),
                )
              : Row(
                  mainAxisSize:
                      expand ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: config.iconSize,
                        color: config.foreground,
                      ),
                      SizedBox(width: config.gap),
                    ],
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: config.fontSize,
                        fontWeight: config.fontWeight,
                        color: config.foreground,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _ButtonConfig _resolveConfig() {
    return switch (variant) {
      AppButtonVariant.primary => _ButtonConfig(
          fill: AppColors.accent,
          foreground: AppColors.textInverted,
          height: AppSizing.buttonHeight,
          radius: AppRadius.card,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          iconSize: AppSizing.iconMd,
          gap: AppSpacing.sm,
        ),
      AppButtonVariant.secondary => _ButtonConfig(
          fill: AppColors.bgCard,
          foreground: AppColors.textPrimary,
          borderColor: AppColors.border,
          height: AppSizing.inputHeight,
          radius: AppRadius.card,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          iconSize: AppSizing.iconMd,
          gap: AppSpacing.sm,
        ),
      AppButtonVariant.danger => _ButtonConfig(
          fill: AppColors.statusOverdue,
          foreground: AppColors.textInverted,
          height: AppSizing.buttonHeight,
          radius: AppRadius.card,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          iconSize: AppSizing.iconMd,
          gap: AppSpacing.sm,
        ),
      AppButtonVariant.ghost => _ButtonConfig(
          fill: Colors.transparent,
          foreground: AppColors.textTertiary,
          borderColor: AppColors.border,
          height: AppSizing.searchHeight,
          radius: AppRadius.input,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          iconSize: AppSizing.iconSm,
          gap: 6,
        ),
    };
  }
}

class _ButtonConfig {
  const _ButtonConfig({
    required this.fill,
    required this.foreground,
    this.borderColor,
    required this.height,
    required this.radius,
    required this.fontSize,
    required this.fontWeight,
    required this.iconSize,
    required this.gap,
  });

  final Color fill;
  final Color foreground;
  final Color? borderColor;
  final double height;
  final double radius;
  final double fontSize;
  final FontWeight fontWeight;
  final double iconSize;
  final double gap;
}
