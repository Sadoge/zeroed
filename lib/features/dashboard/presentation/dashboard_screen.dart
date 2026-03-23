import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/router/app_router.dart';
import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:zeroed/models/invoice_model.dart';
import 'package:zeroed/models/invoice_status.dart';
import 'package:zeroed/models/invoice_summary.dart';
import 'package:zeroed/shared/widgets/invoice_row.dart';
import 'package:zeroed/shared/widgets/loading_shimmer.dart';
import 'package:zeroed/shared/widgets/section_header.dart';
import 'package:zeroed/shared/widgets/summary_card.dart';

import 'package:zeroed/core/utils/currency_utils.dart';
import 'package:zeroed/features/settings/presentation/settings_view_model.dart';

@RoutePage()
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final invoicesAsync = ref.watch(recentInvoicesProvider);
    final clientNamesAsync = ref.watch(clientNameMapProvider);
    final profile = ref.watch(businessProfileProvider).valueOrNull;
    final fmt = currencyFormat(profile?.defaultCurrency ?? 'USD');

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accent,
          backgroundColor: AppColors.bgCard,
          onRefresh: () async {
            ref.invalidate(allInvoicesProvider);
            ref.invalidate(clientNameMapProvider);
            await ref.read(allInvoicesProvider.future);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                _buildHeader(),
                const SizedBox(height: AppSpacing.sectionGap),
                _buildSummarySection(summaryAsync, fmt),
                const SizedBox(height: AppSpacing.sectionGap),
                _buildRecentHeader(),
                const SizedBox(height: AppSpacing.md),
                _buildInvoiceSection(
                    context, invoicesAsync, clientNamesAsync),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text('Zeroed', style: AppTextStyles.heading1),
          ],
        ),
        Container(
          width: AppSizing.iconButtonSize,
          height: AppSizing.iconButtonSize,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.iconButtonBorder,
          ),
          child: Center(
            child: Icon(
              LucideIcons.bell,
              size: AppSizing.iconMd,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Summary Cards ──────────────────────────────────────────

  Widget _buildSummarySection(AsyncValue<InvoiceSummary> async, NumberFormat fmt) {
    return async.when(
      loading: () => Column(
        children: [
          LoadingShimmer.summaryCard(),
          const SizedBox(height: AppSpacing.listGap),
          LoadingShimmer.summaryCard(),
          const SizedBox(height: AppSpacing.listGap),
          LoadingShimmer.summaryCard(),
        ],
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (summary) => _buildSummaryCards(summary, fmt),
    );
  }

  Widget _buildSummaryCards(InvoiceSummary summary, NumberFormat fmt) {
    return Column(
      children: [
        SummaryCard(
          label: 'OUTSTANDING',
          amount: fmt.format(summary.totalOutstanding),
          subtitle: '${summary.invoiceCount} invoices',
        ),
        const SizedBox(height: AppSpacing.listGap),
        SummaryCard(
          label: 'OVERDUE',
          amount: fmt.format(summary.totalOverdue),
          subtitle:
              '${summary.overdueCount} invoice${summary.overdueCount != 1 ? 's' : ''}',
          amountColor: AppColors.statusOverdue,
        ),
        const SizedBox(height: AppSpacing.listGap),
        SummaryCard(
          label: 'PAID THIS MONTH',
          amount: fmt.format(summary.paidThisMonth),
          subtitle: 'this month',
          amountColor: AppColors.statusPaid,
        ),
      ],
    );
  }

  // ─── Recent Invoices ────────────────────────────────────────

  Widget _buildRecentHeader() {
    return SectionHeader(
      title: 'RECENT INVOICES',
      trailing: Text(
        'See All',
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.accent,
        ),
      ),
    );
  }

  Widget _buildInvoiceSection(
    BuildContext context,
    AsyncValue<List<Invoice>> invoicesAsync,
    AsyncValue<Map<String, String>> clientNamesAsync,
  ) {
    return invoicesAsync.when(
      loading: () => Column(
        children: List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.tightListGap),
            child: LoadingShimmer.invoiceRow(),
          ),
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
          child: Text(
            'Failed to load invoices',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ),
      data: (invoices) {
        if (invoices.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: Column(
                children: [
                  Icon(
                    LucideIcons.fileText,
                    size: 40,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No invoices yet',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Tap + to create your first invoice',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final nameMap = clientNamesAsync.valueOrNull ?? {};
        return Column(
          children: invoices.map((invoice) {
            return Padding(
              padding:
                  const EdgeInsets.only(bottom: AppSpacing.tightListGap),
              child: InvoiceRow(
                clientName:
                    resolveClientName(nameMap, invoice.clientId),
                invoiceNumber: invoice.invoiceNumber,
                dateLabel: _formatDateLabel(invoice),
                amount: currencyFormat(invoice.currency).format(invoice.total),
                status: invoice.status,
                onTap: () {
                  context.router
                      .push(InvoiceDetailRoute(invoiceId: invoice.id));
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _formatDateLabel(Invoice invoice) {
    final df = DateFormat('MMM d');
    if (invoice.status == InvoiceStatus.paid && invoice.paidAt != null) {
      return 'Paid ${df.format(invoice.paidAt!)}';
    }
    return 'Due ${df.format(invoice.dueDate)}';
  }
}
