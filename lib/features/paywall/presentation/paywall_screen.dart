import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/features/paywall/presentation/paywall_view_model.dart';

@RoutePage()
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _isAnnual = true;

  static const _monthlyPrice = '\$12.99';
  static const _annualPrice = '\$7.99';

  @override
  Widget build(BuildContext context) {
    final paywallState = ref.watch(paywallNotifierProvider);
    final isLoading = paywallState is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              _buildHeader(context),
              const Spacer(),
              _buildTitle(),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildToggle(),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildPrice(),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildFeatureCard(),
              const Spacer(),
              _buildUpgradeButton(isLoading),
              const SizedBox(height: AppSpacing.lg),
              _buildRestoreLink(isLoading),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.router.maybePop(),
          child: Container(
            width: AppSizing.iconButtonSize,
            height: AppSizing.iconButtonSize,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child:
                  Icon(LucideIcons.x, size: 18, color: AppColors.textPrimary),
            ),
          ),
        ),
        const SizedBox(width: AppSizing.iconButtonSize),
      ],
    );
  }

  // ─── Title ───────────────────────────────────────────────────

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Upgrade to Pro',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Unlock unlimited invoicing power',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ─── Toggle ──────────────────────────────────────────────────

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleTab('Monthly', !_isAnnual, () => setState(() => _isAnnual = false)),
          _toggleTab('Annual', _isAnnual, () => setState(() => _isAnnual = true)),
          if (_isAnnual)
            Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.statusPaidBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Save 37%',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.statusPaid,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _toggleTab(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? AppColors.textInverted : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  // ─── Price ───────────────────────────────────────────────────

  Widget _buildPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _isAnnual ? _annualPrice : _monthlyPrice,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            '/month',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Feature Card ────────────────────────────────────────────

  Widget _buildFeatureCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Column(
        children: [
          // Column headers
          Row(
            children: [
              const Expanded(child: SizedBox()),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    'Free',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    'Pro',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.bgInset),
          const SizedBox(height: 16),
          _featureRow('Invoices / month', freeValue: '5', proInfinity: true),
          const SizedBox(height: 16),
          _featureRow('Auto Reminders'),
          const SizedBox(height: 16),
          _featureRow('Recurring Invoices'),
          const SizedBox(height: 16),
          _featureRow('Custom Branding'),
          const SizedBox(height: 16),
          _featureRow('Tax Export'),
        ],
      ),
    );
  }

  Widget _featureRow(
    String label, {
    String? freeValue,
    bool proInfinity = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              freeValue ?? '—',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
        const SizedBox(width: 40),
        SizedBox(
          width: 40,
          child: Center(
            child: proInfinity
                ? Text(
                    '∞',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  )
                : const Icon(LucideIcons.check,
                    size: 16, color: AppColors.accent),
          ),
        ),
      ],
    );
  }

  // ─── CTA ─────────────────────────────────────────────────────

  Widget _buildUpgradeButton(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : _handleUpgrade,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.textInverted,
                  ),
                )
              : Text(
                  'Upgrade to Pro',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textInverted,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRestoreLink(bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : _handleRestore,
      child: Text(
        'Restore Purchases',
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  // ─── Handlers ────────────────────────────────────────────────

  Future<void> _handleUpgrade() async {
    final packages = ref.read(availablePackagesProvider).valueOrNull ?? [];
    if (packages.isEmpty) {
      _showSnack('No packages available');
      return;
    }

    // Find the matching package
    final target = _isAnnual
        ? packages.where((p) => p.packageType == PackageType.annual).firstOrNull
        : packages
            .where((p) => p.packageType == PackageType.monthly)
            .firstOrNull;

    if (target == null) {
      _showSnack('Package not found');
      return;
    }

    final success =
        await ref.read(paywallNotifierProvider.notifier).purchase(target);
    if (mounted) {
      if (success) {
        context.router.maybePop();
      } else {
        _showSnack('Purchase failed or was cancelled');
      }
    }
  }

  Future<void> _handleRestore() async {
    final success =
        await ref.read(paywallNotifierProvider.notifier).restore();
    if (mounted) {
      if (success) {
        _showSnack('Pro access restored!');
        context.router.maybePop();
      } else {
        _showSnack('No active subscription found');
      }
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.bgCard,
      ),
    );
  }
}
