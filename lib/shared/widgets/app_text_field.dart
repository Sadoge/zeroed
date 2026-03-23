import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';

/// Reusable text field matching design/zeroed.pen input components.
///
/// **Standard (default):** bgCard fill, h50, r10, icon 18, Inter 14
///   → Email, Password, Full Name fields on auth screens
///
/// **Compact:** bgCard fill, h48, r10, icon 18, Inter 14
///   → Option rows, inline inputs on create invoice
///
/// **Search:** bgCard fill, h44, r10, icon 16, Inter 14
///   → Search clients bar
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.label,
    this.labelTrailing,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.compact = false,
    this.search = false,
  });

  final TextEditingController? controller;
  final String? hintText;

  /// Optional label above the field (Inter 12/500, textSecondary).
  final String? label;

  /// Optional trailing widget for the label row (e.g. "Forgot?" link).
  final Widget? labelTrailing;

  /// Optional helper text below the field (Inter 11/400, textTertiary).
  final String? helperText;

  /// Leading icon inside the field (lucide icon).
  final IconData? prefixIcon;

  /// Trailing icon inside the field (e.g. eye-off for password).
  final IconData? suffixIcon;

  /// Tap handler for the suffix icon.
  final VoidCallback? onSuffixTap;

  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;

  /// Use compact height (48) instead of standard (50).
  final bool compact;

  /// Use search style: smaller height (44), smaller icon (16).
  final bool search;

  @override
  Widget build(BuildContext context) {
    final double height = search
        ? AppSizing.searchHeight
        : compact
            ? AppSizing.inputHeight
            : AppSizing.inputHeightLg;
    final double iconSize = search ? AppSizing.iconSm : AppSizing.iconMd;
    final double horizontalPadding = search ? 14 : AppSpacing.lg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          _buildLabel(),
          const SizedBox(height: 6),
        ],
        SizedBox(
          height: height,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofocus: autofocus,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
            cursorColor: AppColors.accent,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: AppColors.bgCard,
              border: OutlineInputBorder(
                borderRadius: AppRadius.inputBorder,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.inputBorder,
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.inputBorder,
                borderSide: const BorderSide(color: AppColors.accent),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 0,
              ),
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: horizontalPadding,
                        right: 10,
                      ),
                      child: Icon(
                        prefixIcon,
                        size: iconSize,
                        color: AppColors.textMuted,
                      ),
                    )
                  : null,
              prefixIconConstraints: prefixIcon != null
                  ? BoxConstraints(
                      minWidth: iconSize + horizontalPadding + 10,
                      minHeight: iconSize,
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Padding(
                        padding: EdgeInsets.only(right: horizontalPadding),
                        child: Icon(
                          suffixIcon,
                          size: iconSize,
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                  : null,
              suffixIconConstraints: suffixIcon != null
                  ? BoxConstraints(
                      minWidth: iconSize + horizontalPadding,
                      minHeight: iconSize,
                    )
                  : null,
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText!,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    final labelWidget = Text(
      label!,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    );

    if (labelTrailing != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [labelWidget, labelTrailing!],
      );
    }

    return labelWidget;
  }
}
