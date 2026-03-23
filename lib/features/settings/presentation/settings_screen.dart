import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/settings/presentation/settings_view_model.dart';
import 'package:zeroed/models/business_profile.dart';
import 'package:zeroed/shared/widgets/section_header.dart';

@RoutePage()
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(businessProfileProvider);

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
              _buildPaymentSection(),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildDefaultsSection(profileAsync),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildNotificationsSection(),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildSubscriptionSection(),
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

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'PAYMENT'),
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
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF34D399),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Connected',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF34D399),
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
      ],
    );
  }

  // ─── Invoice Defaults ────────────────────────────────────────

  Widget _buildDefaultsSection(AsyncValue<BusinessProfile?> profileAsync) {
    final profile = profileAsync.valueOrNull;
    final taxRate = profile != null ? '10%' : '10%';
    final dueDays = profile?.defaultPaymentTermsDays ?? 30;
    final currency = profile?.defaultCurrency ?? 'USD';

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
              _SettingsRow(
                label: 'Default Tax Rate',
                value: taxRate,
                mono: true,
              ),
              const _SettingsDivider(),
              _SettingsRow(
                label: 'Due Date Interval',
                value: '$dueDays days',
              ),
              const _SettingsDivider(),
              _SettingsRow(
                label: 'Currency',
                value: '$currency (\$)',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Notifications ───────────────────────────────────────────

  Widget _buildNotificationsSection() {
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
                      value: true,
                      activeTrackColor: AppColors.accent,
                      onChanged: (_) {
                        // TODO: toggle reminders
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

  Widget _buildSubscriptionSection() {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Free Plan',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '3 of 5 invoices used this month',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            ],
          ),
        ),
      ],
    );
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
  });
  final String label;
  final TextEditingController controller;

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
