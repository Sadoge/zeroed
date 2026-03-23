import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AppButton extends StatefulWidget {
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
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scale = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = _resolveConfig();

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        if (!widget.isLoading) {
          HapticFeedback.lightImpact();
          widget.onPressed?.call();
        }
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.expand ? double.infinity : null,
          height: config.height,
          padding: widget.expand
              ? null
              : const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          decoration: BoxDecoration(
            color: widget.color ?? config.fill,
            borderRadius: BorderRadius.circular(config.radius),
            border: config.borderColor != null
                ? Border.all(color: config.borderColor!)
                : null,
          ),
          child: Center(
            child: widget.isLoading
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
                        widget.expand ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: config.iconSize,
                          color: config.foreground,
                        ),
                        SizedBox(width: config.gap),
                      ],
                      Text(
                        widget.label,
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
      ),
    );
  }

  _ButtonConfig _resolveConfig() {
    return switch (widget.variant) {
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
