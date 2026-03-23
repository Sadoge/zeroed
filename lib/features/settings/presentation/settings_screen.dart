import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:zeroed/core/constants/app_constants.dart';
import 'package:zeroed/core/router/app_router.dart';
import 'package:zeroed/core/services/stripe_service.dart';
import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/auth/presentation/auth_view_model.dart';
import 'package:zeroed/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:zeroed/features/settings/presentation/settings_view_model.dart';
import 'package:zeroed/models/business_profile.dart';
import 'package:zeroed/core/utils/currency_utils.dart';
import 'package:zeroed/shared/widgets/section_header.dart';

@RoutePage()
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(businessProfileProvider);
    final subscriptionAsync = ref.watch(subscriptionProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('Settings', style: AppTextStyles.heading1),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildProfileSection(context, ref, profileAsync),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildPaymentSection(context, ref, profileAsync),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildDefaultsSection(context, ref, profileAsync),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildNotificationsSection(context, ref, profileAsync),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildSubscriptionSection(context, ref, subscriptionAsync),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildSignOutButton(context, ref),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Business Profile ────────────────────────────────────────

  Widget _buildProfileSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<BusinessProfile?> profileAsync,
  ) {
    final profile = profileAsync.valueOrNull;
    final name = profile?.businessName ?? 'Your Business Name';
    final email = profile?.email ?? 'you@email.com';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'BUSINESS PROFILE'),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: () => _showEditProfileSheet(context, ref, profile),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: AppRadius.cardBorder,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.bgInset,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.user,
                        size: 22, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight,
                    size: AppSizing.iconSm, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Payment ─────────────────────────────────────────────────

  Widget _buildPaymentSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<BusinessProfile?> profileAsync,
  ) {
    final isConnected = profileAsync.valueOrNull?.stripeConnected ?? false;
    final statusColor =
        isConnected ? const Color(0xFF34D399) : AppColors.textMuted;
    final statusText = isConnected ? 'Connected' : 'Not connected';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'PAYMENT'),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: () => _handleStripeConnect(context, ref, isConnected),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: AppRadius.cardBorder,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF635BFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'S',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stripe',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: statusColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              statusText,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(LucideIcons.chevronRight,
                    size: AppSizing.iconSm, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Invoice Defaults ────────────────────────────────────────

  Widget _buildDefaultsSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<BusinessProfile?> profileAsync,
  ) {
    final profile = profileAsync.valueOrNull;
    final taxRate = '${profile?.defaultTaxRate ?? 10.0}%';
    final dueDays = profile?.defaultPaymentTermsDays ?? 30;
    final currency = profile?.defaultCurrency ?? 'USD';
    final symbol = currencySymbols[currency] ?? currency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'INVOICE DEFAULTS'),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.cardBorder,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showEditTaxRateSheet(context, ref, profile),
                child: _SettingsRow(
                  label: 'Default Tax Rate',
                  value: taxRate,
                  mono: true,
                ),
              ),
              const _SettingsDivider(),
              GestureDetector(
                onTap: () => _showEditDueDaysSheet(context, ref, profile),
                child: _SettingsRow(
                  label: 'Due Date Interval',
                  value: '$dueDays days',
                ),
              ),
              const _SettingsDivider(),
              GestureDetector(
                onTap: () => _showEditCurrencySheet(context, ref, profile),
                child: _SettingsRow(
                  label: 'Currency',
                  value: '$currency ($symbol)',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Notifications ───────────────────────────────────────────

  Widget _buildNotificationsSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<BusinessProfile?> profileAsync,
  ) {
    final profile = profileAsync.valueOrNull;
    final remindersEnabled = profile?.remindersEnabled ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'NOTIFICATIONS'),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.cardBorder,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Reminders',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    CupertinoSwitch(
                      value: remindersEnabled,
                      activeTrackColor: AppColors.accent,
                      onChanged: (val) {
                        if (profile != null) {
                          final updated =
                              profile.copyWith(remindersEnabled: val);
                          ref
                              .read(profileEditorProvider.notifier)
                              .updateProfile(updated);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const _SettingsDivider(),
              const _SettingsRow(
                label: 'Reminder Schedule',
                value: '3, 7, 14 days',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Subscription ────────────────────────────────────────────

  Widget _buildSubscriptionSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue subscriptionAsync,
  ) {
    final isPro = subscriptionAsync.valueOrNull?.isPro ?? false;
    final planName = isPro ? 'Pro Plan' : 'Free Plan';

    final invoicesAsync = ref.watch(allInvoicesProvider);
    final invoices = invoicesAsync.valueOrNull ?? [];
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final thisMonthCount =
        invoices.where((i) => i.createdAt.isAfter(monthStart)).length;

    final usageText = isPro
        ? '$thisMonthCount invoices this month'
        : '$thisMonthCount of ${AppConstants.freeInvoiceLimit} invoices used this month';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'SUBSCRIPTION'),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.cardBorder,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      usageText,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isPro)
                GestureDetector(
                  onTap: () => context.router.push(const PaywallRoute()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Upgrade',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textInverted,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Sign Out ──────────────────────────────────────────────

  Widget _buildSignOutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: AppSizing.buttonHeight,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
        ),
        onPressed: () async {
          await ref.read(authViewModelProvider.notifier).signOut();
          if (context.mounted) {
            context.router.replaceAll([const SignInRoute()]);
          }
        },
        child: Text(
          'Sign Out',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ─── Stripe Connect ──────────────────────────────────────────

  Future<void> _handleStripeConnect(
    BuildContext context,
    WidgetRef ref,
    bool isConnected,
  ) async {
    if (isConnected) return;

    try {
      final url = await ref
          .read(stripeServiceProvider)
          .createConnectOnboardingLink();
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start Stripe setup: $e'),
            backgroundColor: AppColors.bgCard,
          ),
        );
      }
    }
  }

  // ─── Edit Profile Sheet ──────────────────────────────────────

  void _showEditProfileSheet(
    BuildContext context,
    WidgetRef ref,
    BusinessProfile? profile,
  ) {
    final nameCtrl =
        TextEditingController(text: profile?.businessName ?? '');
    final addressCtrl =
        TextEditingController(text: profile?.address ?? '');
    final taxIdCtrl =
        TextEditingController(text: profile?.taxId ?? '');

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xl,
          MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Profile', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.lg),
            _SheetField(label: 'Business Name', controller: nameCtrl),
            const SizedBox(height: AppSpacing.md),
            _SheetField(label: 'Address', controller: addressCtrl),
            const SizedBox(height: AppSpacing.md),
            _SheetField(label: 'Tax ID', controller: taxIdCtrl),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: AppSizing.buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textInverted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.input),
                  ),
                ),
                onPressed: () {
                  if (profile != null) {
                    final updated = profile.copyWith(
                      businessName: nameCtrl.text.trim().isEmpty
                          ? null
                          : nameCtrl.text.trim(),
                      address: addressCtrl.text.trim().isEmpty
                          ? null
                          : addressCtrl.text.trim(),
                      taxId: taxIdCtrl.text.trim().isEmpty
                          ? null
                          : taxIdCtrl.text.trim(),
                    );
                    ref
                        .read(profileEditorProvider.notifier)
                        .updateProfile(updated);
                  }
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Edit Tax Rate Sheet ─────────────────────────────────────

  void _showEditTaxRateSheet(
    BuildContext context,
    WidgetRef ref,
    BusinessProfile? profile,
  ) {
    final ctrl = TextEditingController(
      text: (profile?.defaultTaxRate ?? 10.0).toString(),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xl,
          MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Default Tax Rate', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.lg),
            _SheetField(
              label: 'Tax Rate (%)',
              controller: ctrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: AppSizing.buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textInverted,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.input),
                  ),
                ),
                onPressed: () {
                  if (profile != null) {
                    final parsed =
                        double.tryParse(ctrl.text.trim()) ?? 10.0;
                    final updated =
                        profile.copyWith(defaultTaxRate: parsed);
                    ref
                        .read(profileEditorProvider.notifier)
                        .updateProfile(updated);
                  }
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Edit Due Days Sheet ─────────────────────────────────────

  void _showEditDueDaysSheet(
    BuildContext context,
    WidgetRef ref,
    BusinessProfile? profile,
  ) {
    final currentDays = profile?.defaultPaymentTermsDays ?? 30;
    const options = [7, 14, 15, 30, 45, 60, 90];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Due Date Interval', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.lg),
            ...options.map((days) => _OptionTile(
                  label: '$days days',
                  selected: days == currentDays,
                  onTap: () {
                    if (profile != null) {
                      final updated = profile.copyWith(
                          defaultPaymentTermsDays: days);
                      ref
                          .read(profileEditorProvider.notifier)
                          .updateProfile(updated);
                    }
                    Navigator.of(ctx).pop();
                  },
                )),
          ],
        ),
      ),
    );
  }

  // ─── Edit Currency Sheet ─────────────────────────────────────

  void _showEditCurrencySheet(
    BuildContext context,
    WidgetRef ref,
    BusinessProfile? profile,
  ) {
    final currentCurrency = profile?.defaultCurrency ?? 'USD';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Currency', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.lg),
            ...currencySymbols.entries.map((entry) => _OptionTile(
                  label: '${entry.key} (${entry.value})',
                  selected: entry.key == currentCurrency,
                  onTap: () {
                    if (profile != null) {
                      final updated =
                          profile.copyWith(defaultCurrency: entry.key);
                      ref
                          .read(profileEditorProvider.notifier)
                          .updateProfile(updated);
                    }
                    Navigator.of(ctx).pop();
                  },
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable Row Widgets ──────────────────────────────────────

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.label,
    required this.value,
    this.mono = false,
  });
  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: mono
                    ? GoogleFonts.jetBrainsMono(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      )
                    : GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
              ),
              const SizedBox(width: 4),
              const Icon(LucideIcons.chevronRight,
                  size: 14, color: AppColors.textMuted),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.bgInset,
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.label,
    required this.controller,
    this.keyboardType,
  });
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bgInset,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: AppRadius.inputBorder,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            if (selected)
              const Icon(LucideIcons.check,
                  size: 18, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
