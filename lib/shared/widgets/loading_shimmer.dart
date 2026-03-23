import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:zeroed/core/theme/app_colors.dart';

/// Reusable shimmer loading placeholder.
///
/// Wraps child in a shimmer effect using the app's dark palette.
class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgCard,
      highlightColor: AppColors.bgInset,
      child: child,
    );
  }

  /// Convenience: a shimmer rectangle with rounded corners.
  static Widget rectangle({
    double width = double.infinity,
    double height = 16,
    double borderRadius = 8,
  }) {
    return LoadingShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Convenience: a shimmer card matching SummaryCard dimensions.
  static Widget summaryCard() {
    return LoadingShimmer(
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Convenience: a shimmer row matching InvoiceRow dimensions.
  static Widget invoiceRow() {
    return LoadingShimmer(
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
